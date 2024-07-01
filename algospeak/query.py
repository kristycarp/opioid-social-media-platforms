# Note that this script requires the OpenAI API -- you must set up an API key and store it in .env to use this script

import os
import requests
import json
import openai
import time
from dotenv import load_dotenv
import argparse


def query(args):
    load_dotenv()

    openai.api_key = os.getenv("AZURE_OPENAI_KEY")
    openai.api_base = os.getenv("AZURE_OPENAI_ENDPOINT")
    openai.api_type = 'azure' # from quickstart documentation
    openai.api_version = '2023-05-15' # from quickstart documentation

    deployment_name = os.getenv("DEPLOYMENT_NAME")

    examples_dict = {"codeine": "c0dein3, c0dine, cod eine",
                     "fentanyl": "f3ntanyl, f3nt, f3ntanil",
                     "morphine": "m0rphine, morf1ne, m0rph1n3",
                     "oxycodone": "0xy, 0xyc0d0n, p3rcs",
                     "oxymorphone": "0xym0rph0ne, 0pana, num0rph@n"}
    examples = examples_dict[args.drug]


    context = "You are an AI assistant that helps people find information. You are particularly hip with online slang and know everything about how people talk on social media platforms like Facebook, Twitter, Reddit, and TikTok."
    prompt = "We are playing a game where I give you a word, and then you give me algospeak terms for that word. The algospeak must be in the format such that none of the included words would be present in an English dictionary. I will give you an example; please continue each of these comma-separated lists:\n1. dog: d0g, pupper, doggo\n2. die: d!e, unalive, d!3\n3. %s: %s\n4. friend: fr13nd, @mig0, frend\nIn your response, only give the four lists (for dog, die, %s, and friend) with comma-separated terms. Do not include any other text." % (args.drug, examples, args.drug)
    outname = "%s-output.txt" % args.drug

    for _ in range(args.n):
        response = openai.ChatCompletion.create(
                    engine = deployment_name,
                    temperature = 0.7,
                    messages=[
                                {"role": "system", "content": context},
                                {"role": "user", "content": prompt} 
                             ]
                        )

        message = response['choices'][0]['message']['content']
        with open(outname,'a') as outfile:
            outfile.write(message)
            outfile.write("\n")
        time.sleep(0.5)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--drug", type=str, default="fentanyl", help="name of drug to query for")
    parser.add_argument("-n", type=int, default=3, help="number of query repetitions")
    args = parser.parse_args()
    query(args)
