import sys

TAB = "    "

if len(sys.argv) != 5:
    print("Usage:\n"+TAB+"python simple_tb_gen.py module_name input_variables output_variables (no_clock/has_clock)")
    exit(0)
else:
    module_name  = sys.argv[1]
    input_vars   = sys.argv[2]
    output_vars  = sys.argv[3]
    has_clock    = "has_clock" in sys.argv

input_vars_list = input_vars.split(',')
output_vars_list = output_vars.split(',')
# Handle vectors:
for _list in (input_vars_list, output_vars_list):
    for i in range(len(_list)):
        var = _list[i]
        var_obj = {"name":var.strip(),"vec_length":1,"vec_slice":""}
        if var.find('[')>-1 and var.find(']')>-1 and var.find(':')>-1 and var.find('[')<var.find(':')<var.find(']'):var_obj["vec_length"] = abs(eval(var[var.find('[')+1:var.find(':')]) - eval(
var[var.find(':')+1:var.find(']')]))+1 
        var_obj["name"] = var[:var.find('[')].strip()
        var_obj["vec_slice"] = var[var.find('['):]
        _list[i] = var_obj

print(f"module {module_name}_tb;")

input_vars_decl  = f";\n{TAB}reg {TAB}".join([x["vec_slice"]+TAB+x["name"] for x in input_vars_list])
output_vars_decl = f";\n{TAB}wire{TAB}".join([x["vec_slice"]+TAB+x["name"] for x in output_vars_list])
print(TAB + "// Step 1: Define test bench variables and clock:")
print(TAB + "reg " + TAB + input_vars_decl + "; // Inputs as register data type (so we can assign them in the initial block)")
print(TAB + "wire" + TAB + output_vars_decl + "; // Outputs as wire data type (as they are assigned by the DUT)\n")
if (has_clock):
    print(TAB + "reg clk;  // Clock signal for sequential logic")
else:
    print(TAB + "// reg clk; // (Clock not needed for this simulation.)")

print()
print(TAB + "// Step 2: Instantiate Device Under Test:")
print(TAB + module_name, "DUT( // Instantiate the 'Device Under Test' (DUT), an instanceof the",module_name,"module.")
input_port_list = ", ".join(['.'+x["name"]+'('+x["name"]+')' for x in input_vars_list])
output_port_list = ", ".join(['.'+x["name"]+'('+x["name"]+')' for x in output_vars_list]
)
print(2*TAB + input_port_list + ', // Connect inputs to their respective testbench variables.')
print(2*TAB + output_port_list + "  // Connect outputs to their respective testbench variables.")
print(TAB + ");")
print(TAB + "// ^^^ Connects ports of the instantiated module to variables in this module with the same port/variable name.")

print()
print(TAB + "// Step 3: Toggle the clock variable every 10 time units to create a clock signal **with period = 20 time units**:")
if (has_clock):
    print(TAB + "initial forever #10 clk = ~clk; // forever is an infinite loop!")
else:
    print(TAB + "// initial forever #10 clk = ~clk; // forever is an infinite loop!")
    print(TAB + "// (Clock not needed for this simulation.)")

print()
print(TAB + "// Step 4: Initial block to specify input values starting from time = 0. Tospecify inputs for time > 0, use the delay operator `#`.")
print(TAB + "initial begin  // Run the following code starting from the beginning of thesimulation:")
print(2*TAB + "$dumpfile(\"waveform.vcd\");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.")
print(2*TAB + "$dumpvars();                // Also required to tell simulator to dump variables into a waveform (with filename specified above).")
print()
print(2*TAB + "repeat(15) begin // Generate random input stimuli (15 times):")
print(3*TAB + "// Set each input bit to random value (0 or 1):")
input_list_bits = sum([x["vec_length"] for x in input_vars_list])
input_vars_names = ', '.join([x["name"] for x in input_vars_list])
output_vars_names = ', '.join([x["name"] for x in output_vars_list])
if input_list_bits > 32: print(3*TAB+"Your inputs sum to more than a total of 32 bits! The following line will not work:")
print(3*TAB + "{" + input_vars_names + "} =", str(input_list_bits)+"'($urandom()); // Generate a random unsigned 32-bit value ($urandom), then cast it", "("+str(input_list_bits)+"') to a", str(input_list_bits)+"-bit value. The inputs",input_vars_names,"are then assigned to each bit of this value (in the order: MSB to LSB).")
print(3*TAB + "// ^^^ We use the LHS concatenation operator here to efficiently assign each of the", input_list_bits, "inputs to a random 1-bit value.")
input_print_list = ', '.join([x["name"]+": %b" for x in input_vars_list])
output_print_list = ', '.join([x["name"]+": %b" for x in output_vars_list])
print(3*TAB + "// Log input and output values:")
print(3*TAB + "$display(\"Inputs: \\t"+input_print_list+"\", "+input_vars_names+"); // Print inputs to stdout.")
print(3*TAB + "#10; // Delay for 10 time units to ensure the simulator evaluates the DUToutputs before the next line.")
print(3*TAB + "$display(\"Outputs:\\t"+output_print_list+"\", "+output_vars_names+"); //Print outputs to stdout.")
print(3*TAB + "$display(\"======================================\");")
print(3*TAB + "#10; // Delay for a further 10 time units to provide a total of 20 time units between input changes (as the clock period is 20 time units).")
print(2*TAB + "end")
print()
print(2*TAB + "$finish(); // Important: must end simulation (or it will go on forever!)"
)
print(TAB + "end")

print("endmodule")