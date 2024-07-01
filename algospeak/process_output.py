import argparse

def process(args):
    outfname = "%s-output.txt" % args.drug
    drugfname = "%s-processed-out.txt" % args.drug
    errorfname = "%s-error-out.txt" % args.drug

    examples_dict = {"codeine": "c0dein3, c0dine, cod eine",
                     "fentanyl": "f3ntanyl, f3nt, f3ntanil",
                     "morphine": "m0rphine, morf1ne, m0rph1n3",
                     "oxycodone": "0xy, 0xyc0d0n, p3rcs",
                     "oxymorphone": "0xym0rph0ne, 0pana, num0rph@n"}
    examples = examples_dict[args.drug].split(",")

    outf = open(outfname,"r")
    drugf = open(drugfname,"w")
    errorf = open(errorfname,"w")

    for line in outf.read().split("\n"):
        if len(line) < 2:
            continue
        if line[:2] == "1." or line[:2] == "2." or line[:2] == "4.":
            continue
        if line[:3] == "3. ":
            if ":" in line:
                spl = line[3:].split(":")
                if spl[0].lower() == args.drug or spl[0].lower() in examples:
                    clean_line = spl[1].split(",")
                else:
                    errorf.write(line)
                    errorf.write("\n")
                    continue
            else:
                clean_line = line[3:].split(",")
            for elem in clean_line:
                drugf.write(elem.strip())
                drugf.write("\n")
        else:
            errorf.write(line)
            errorf.write("\n")
    outf.close()
    drugf.close()
    errorf.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--drug", type=str, help="drug to read output file for")
    args = parser.parse_args()
    process(args)
