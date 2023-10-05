import requests
import time
from requests.exceptions import ConnectionError

latin_names_file = "latin_names.txt"
common_names_file = "common_names_itis.txt"

def get_itis_data(latin_name):
    url = f"https://www.itis.gov/ITISWebService/jsonservice/searchByScientificName?srchKey={latin_name}"
    
    while True:
        try:
            response = requests.get(url)
            data = response.json()
            return data
        except ConnectionError:
            time.sleep(5)  # Wait for 5 seconds before retrying the request

def get_itis_common_name(tsn):
    url = f"https://www.itis.gov/ITISWebService/jsonservice/getCommonNamesFromTSN?tsn={tsn}"
    
    while True:
        try:
            response = requests.get(url)
            data = response.json()

            if data.get("commonNames") and data["commonNames"][0] is not None:
                return data["commonNames"][0]["commonName"]
            else:
                return "Not found"
        except ConnectionError:
            time.sleep(5)  # Wait for 5 seconds before retrying the request

with open(latin_names_file, "r") as f, open(common_names_file, "w") as output:
    for line in f:
        latin_name = line.strip()
        data = get_itis_data(latin_name)
        
        if data.get("scientificNames") and data["scientificNames"][0] is not None:
            tsn = data["scientificNames"][0].get("tsn")
            if tsn:
                common_name = get_itis_common_name(tsn)
            else:
                common_name = "Not found"
        else:
            common_name = "Not found"

        output.write(f"{latin_name}: {common_name}\n")
        time.sleep(2)  # Add a 2-second delay between requests

