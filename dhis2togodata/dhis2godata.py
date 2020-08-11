import os
from os.path import isfile
from os import listdir
from os.path import join
import json
import re
import sys

level_code = "LNG_REFERENCE_DATA_CATEGORY_LOCATION_GEOGRAPHICAL_LEVEL_ADMIN_LEVEL_%s"
file = "config.json"
godata_skell = {"children": "%s",
                "location": {"geoLocation": {"lng": "%s", "lat": "%s"},
                             "identifiers": [{"code": "%s"}],
                             "name": "%s", "active": True,
                             "id": "%s", "populationDensity": 0,
                             "identifiers": [],
                             "geoLocation": None,
                             "geographicalLevelId": "%s",
                             "parentLocationId": "%s"}}
relations = dict()


def main():
    root_org_unit_uid = ""

    cfg = get_config("config.json")
    root_level = cfg["root_level"]
    input = cfg["input_dir"]
    output = cfg["output_dir"]

    is_json = lambda fname: os.path.splitext(fname)[-1] in ['.json']
    is_not_json = lambda fname: not os.path.splitext(fname)[-1] in ['.json']
    is_not_git = lambda fname: not fname.startswith(".git")
    applied_filter = is_not_git if is_json else is_not_json

    files = [f for f in filter(applied_filter, listdir(input)) if isfile(join(input, f))]
    for path_file in files:
        print("generating " + path_file)
        with open(os.path.join(input, path_file), encoding='utf8') as json_file:
            objects = json.load(json_file)

            for orgunit in objects["organisationUnits"]:
                if str(orgunit["level"]) == root_level:
                    root_org_unit_uid = orgunit["id"]
                    break

            godata_orgunits = create_godata_org_unit(root_org_unit_uid, objects, root_level)

            with open(join(output, path_file), 'w', encoding='utf-8') as outfile_json:
                json.dump([godata_orgunits], outfile_json, indent=4, ensure_ascii=False)
                print("Done " + path_file)


def get_config(fname):
    "Return dict with the options read from configuration file"
    print('Reading from config file %s ...' % fname)
    try:
        with open(fname) as f:
            config = json.load(f)
    except (AssertionError, IOError, ValueError) as e:
        sys.exit('Error reading config file %s: %s' % (fname, e))
    return config


def get_latitude(coordinates):
    return re.findall(r"[-]?\d+\.\d+", coordinates)[0]


def get_longitude(coordinates):
    return re.findall(r"[-]?\d+\.\d+", coordinates)[1]


def get_children(geodata_orgunit, active_org_unit, objects, root_level):
    children = geodata_orgunit["children"]
    children_uids = list()
    for uid in active_org_unit["children"]:
        children_uids.append([uid["id"]])
    if len(children_uids) > 0:
        # reverse list
        children_uids = children_uids[::-1]
    else:
        return geodata_orgunit
    for uid in children_uids:
        org_unit = create_godata_org_unit(uid, objects, root_level)
        children.append(org_unit)
    geodata_orgunit["children"] = children
    return geodata_orgunit


def get_parent(parent_uid, org_units, godata_level):
    if godata_level == 0:
        return None
    for org_unit in org_units["organisationUnits"]:
        if org_unit["id"] == parent_uid:
            if "code" in org_unit.keys():
                return parent_uid
    return None


def create_godata_org_unit(uid, objects, root_level):
    for org_unit in objects["organisationUnits"]:
        if org_unit["id"] in uid:

            godata_level = org_unit["level"] - int(root_level)
            latitude = ""
            longitude = ""
            if "coordinates" in org_unit.keys() and "featureType" in org_unit.keys() and org_unit[
                "featureType"] == "POINT":
                latitude = get_latitude(org_unit["coordinates"])
                longitude = get_longitude(org_unit["coordinates"])
            uid = org_unit["id"]
            if "code" in org_unit.keys():
                code = org_unit["code"]
            else:
                code = uid

            if int(root_level) == org_unit["level"]:
                parent = None
            else:
                parent = get_parent(org_unit["parent"]["id"], objects, godata_level)

            geodata_orgunit = {"location": {
                                            "name": org_unit["name"],
                                            "synonyms": [],
                                            "identifiers": [{"code": code}],
                                            "active": True,
                                            "parentLocationId": parent,
                                            "geoLocation": None,
                                            "geographicalLevelId": (level_code % godata_level),
                                            "id": uid
            },
                                "children": []}

            if latitude != "" or longitude != "":
                geodata_orgunit["geoLocation"]: {"lng": latitude, "lat": longitude}
            if godata_level == 0 :
                geodata_orgunit["populationDensity"] = 0
            get_children(geodata_orgunit, org_unit, objects, root_level)
            return geodata_orgunit


if __name__ == '__main__':
    main()
