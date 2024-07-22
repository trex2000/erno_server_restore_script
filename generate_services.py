import sys

#function for opening the file for reading with utf-8 encoding
def open_file_for_reading(file_path):
    try:
        return open(file_path, 'r', encoding='utf-8')
    except FileNotFoundError:
        print(f"File '{file_path}' not found.")
        return None

#function for opening the file for writing with utf-8 encoding   
def open_file_for_writing(file_path):
    try:
        return open(file_path, 'w', encoding='utf-8')
    except FileNotFoundError:
        print(f"File '{file_path}' not found.")
        return None

#function for reading the blocks of providers from the file, first block is skipped because it is some comment in the file
def read_blocks(file, skip_first_block=True):
    blocks = []
    current_block = []
    skip_next_empty_line = skip_first_block
    for line in file:
        line = line.strip()
        if not line:
            if current_block:
                if not skip_next_empty_line:
                    blocks.append(current_block)
                else:
                    skip_next_empty_line = False
                current_block = []
        else:
            current_block.append(line)
    if current_block:
        blocks.append(current_block)
    return blocks

# Example usage: Read blocks from "input.txt" separated by empty lines, skipping the first block
#input_file = "oscam.srvid"
if (len(sys.argv) != 3 ):
    print("Usage: generate_services.py [INPUT_FILE_PATH] [OUTPUT_FILE_PATH]")
    exit
input_file = sys.argv[1]
output_file = sys.argv[2]
#output_file = "oscam.service"
in_file = open_file_for_reading(input_file)
out_file = open_file_for_writing(output_file)
if out_file:
    sys.stdout = out_file

if in_file:
    blocks = read_blocks(in_file, skip_first_block=True)
    if blocks:
        #iterates throu the blocks of providers 1 by 1
        for i, block in enumerate(blocks, start=1):
            #defining and printing prvider name
            provider_name = block[0].split('|')[1]
            print("[" + provider_name + "]")
            #defining and printing CAID list
            caid_list = block[0].split('|')[0].split(':')[0].split(',')
            if "1830" in caid_list :
                caid_list.append(1843)
            print("caid = ", end="")
            print(*caid_list, sep=", ")
            #defining and printing PROVID 000000
            print("provid = 000000")
            srvid_list = []
            #generating and printing SRVID list
            for line in block:
                attributes = line.split('|')
                caid_srvid = attributes[0]
                srvid = caid_srvid.split(':')[1]
                srvid_list.append(srvid)
            #defining and printing SRVID list
            print("srvid = ", end="")
            print(*srvid_list, sep=", ")
            print()
    in_file.close()