import math

def main():
    
    while True:

        temp_value = input("Enter Offset and Lvl Offset: ")
        if temp_value == "end":
            break

        maxvalue = 2**11 - 1
        splitted = temp_value.split()
        offset = int(splitted[0])
        lvl_offset = int(splitted[1])

        initial_values = (offset, maxvalue)
        for i in range(4):
            for j in initial_values:
                print(j/2**i + lvl_offset, end = " ")
            print()



if __name__ == '__main__':
    main()