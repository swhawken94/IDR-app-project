import numpy as np

def main():
    f = open("idr_sequence_file.csv", 'r')
    lines_list = []
    for line in f:
        lines_list.append(line)
    
    print(len(lines_list))
    new_lines_list = []
    stitch_count = np.zeros(len(lines_list))
    for i in range(0,len(lines_list)):
        if(i+1 < len(lines_list)):
            line_split_1 = lines_list[i].split("\t")
            line_split_2 = lines_list[i+1].split("\t")
        
            if ((line_split_1[0] == line_split_2[0]) and int(line_split_1[2])+10 == int(line_split_2[1])):
                start = int(line_split_1[1])
                end = int(line_split_2[2])
                new_idr = line_split_1[6][start:end]
                new_line = line_split_1[0]+"\t"+line_split_1[1]+"\t"+line_split_2[2]+"\t"+line_split_1[4]+"\t"+new_idr+"\t"+str(len(new_idr))
                new_lines_list.append(new_line)
                stitch_count[i] = 1
                stitch_count[i+1] = 1
            elif stitch_count[i] == 0:
                start = int(line_split_1[1])
                end = int(line_split_1[2])
                new_idr = line_split_1[6][start:end]
                new_line = line_split_1[0]+"\t"+line_split_1[1]+"\t"+line_split_1[2]+"\t"+line_split_1[4]+"\t"+new_idr+"\t"+str(len(new_idr))
                new_lines_list.append(new_line)
            

    p = open("stitched_ten_idr_sequences_test.csv",'w')
    for line in new_lines_list:
        p.write(line)
        p.write("\n")
if __name__ == "__main__":
    main()
