#!/usr/bin/env python
"""Parses CWL's "SoftwareRequirement" hints section and dumps a cbl compatible yaml file.

The purpose with this script is to create smaller composable docker containers for bcbio-nextgen.

Usage: cwl2yaml_packages.py --outdir ["packages"] <path> <to one or more> <cwl-workflow> <directories>
"""
import argparse
import collections
import glob
import os
import sys
import yaml

import cwltool.load_tool
import cwltool.workflow

def main(cwl_dirs, out_dir):
    packages_by_image = collections.defaultdict(set)
    for cwl_dir in cwl_dirs:
        main_file = glob.glob(os.path.join(cwl_dir, "main-*.cwl"))[0]
        main_wf = cwltool.load_tool.load_tool(main_file, cwltool.workflow.defaultMakeTool)
        packages_by_image = get_step_packages(main_wf, packages_by_image)

    for docker_image, packages in packages_by_image.items():
        out_file = os.path.join(out_dir, "%s.yaml" % docker_image.split("/")[-1])

        cbl_yml = {'channels': ['bioconda', 'conda-forge', 'r'],
                   'minimal': ["anaconda-client", "awscli", "nodejs", "ncurses"],
                   'bio_nextgen': sorted(list(packages))}
        with open(out_file, "w") as out_handle:
            yaml.safe_dump(cbl_yml, out_handle, default_flow_style=False, allow_unicode=False)

def get_step_packages(wf, out):
    for step in wf.steps:
        if isinstance(step.embedded_tool, cwltool.workflow.Workflow):
            out = get_step_packages(step.embedded_tool, out)
        else:
            docker_image = None
            software = set([])
            for req in step.embedded_tool.requirements + step.embedded_tool.hints:
                if req["class"] == "DockerRequirement":
                    docker_image = req["dockerImageId"]
                elif req["class"] == "SoftwareRequirement":
                    for package in req["packages"]:
                        name = package["package"]
                        if "version" in package:
                            name += "=%s" % package["version"][0]
                        software.add(name)
            if software:
                assert docker_image
                out[docker_image] |= software
    return out

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert CWL SoftwareRequirements into CloudBioLinux YAML")
    parser.add_argument("--outdir", help="Output directory for YAML files", default="packages")
    parser.add_argument("cwl_dirs", nargs="*", help="CWL directories to read and process")
    if len(sys.argv) == 1:
        parser.print_help()
    args = parser.parse_args()
    main(args.cwl_dirs, args.outdir)
