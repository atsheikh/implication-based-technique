#############################################################################
#																			#
# A script to draw the graph of a circuit from a bench file. 				#
#																			#
#																			#
# USAGE = perl draw-graph.pl [bench file name without extension]			#
#  ex: perl con1															#		
#																			#		
#																			#		
# Author: Ahmad Tariq Sheikh.												#
#																			#
# Date: September 2, 2015													#
#############################################################################

#!/usr/bin/perl -w

use warnings;
use Cwd;
use Time::HiRes;
#----------------------------------------------------

sub createGraphFile {
	local (*FILE) = @_;
	open(OUTPUT_FILE, ">tempfile1.txt"); #open for write, overwrite		
	print OUTPUT_FILE "digraph G { \n";
	print OUTPUT_FILE "\tgraph [center=1 rankdir=LR bgcolor=$bgColor]\n";
	print OUTPUT_FILE "\tedge [dir=$edgeDirection fontsize=$fontSize fontname=$fontName]\n";	
	
	#-------------------------------------------------------------------------
	#PASS-1:- Create the graph file and find intermediate gates and stems
	#-------------------------------------------------------------------------
	while (<FILE>) {
		
		if ($flag == 0) {  #To read the number of primary inputs and outputs value.		
			if ($_ =~ m/(.*)inputs/) {				
				if ($1 =~ m/(\d+)/) {				
					$numberOfPrimaryInputs = $1;			
				}
			}			
			elsif ($_ =~ m/(.*)outputs/) {			
				if ($1 =~ m/(\d+)/) {				
					$numberOfPrimaryOutputs = $1;			
					$flag = 1;	
				}
			}					
		}
		elsif($flag == 1) { #create input nodes list.		
			print "$numberOfPrimaryInputs \n";
			print OUTPUT_FILE "\t{node[shape=point style=filled color=yellow fixedsize=1 width=0.15]\n";
			print OUTPUT_FILE "\t\t\t";
			for my $i(0..$numberOfPrimaryInputs-1) {			
				print  OUTPUT_FILE "v$i ";
				$IOgates[$i] = "v$i";
			}				
			$flag=2;
		}		
		elsif($flag == 2) { #create output node list			
			if ($_ =~ m/OUTPUT(.*)/) {			
				if ($1 =~ m/(\d+)/) {				
					$outputStart = $1;						
				}
				for my $i(0..$numberOfPrimaryOutputs-1) {
					$out = "v$outputStart"."_".$i;				
					print OUTPUT_FILE "V$out ";
					push(@IOgates,"V$out");					
				}
				print OUTPUT_FILE "\n\t}\n";										
				$flag=3;								
			}
		}
		elsif($flag == 3) { #wait for the last line of output list to appear in the file read		
			my $lastoutput = $outputStart+$numberOfPrimaryOutputs-1;
			if ($_ =~ m/OUTPUT\(v$lastoutput\)/) {
				$flag=4;	
			}
			elsif ($lastoutput == $outputStart) {
					$flag=4;	
			}			
		}
		elsif ($flag == 4) { #read the gate connections, beginning of actual graph drawing statements generation
			if ($_ =~ m/#/ or $_ =~ m/^\s/) {			
				next;
			}
			else {				
				computeStems($_);					
				print OUTPUT_FILE "\t$_";				
			}
		}		
	}
	
	#Draw Final output edges from their terminal gates.
	print OUTPUT_FILE "\n";
	for my $i(0..$numberOfPrimaryOutputs-1) {
		# print "O start: $outputStart \n"; exit;
		$out = "v$outputStart"."_".$i;
		$intermediateOutputGates{$out} = 1;
		print OUTPUT_FILE "\t$out->V$out [label=\"$out\" color=$stuckAt0Clr dir=$edgeDirection penwidth=$penWidth]\n";			
	}
	print OUTPUT_FILE "\n}\n";
	close(OUTPUT_FILE); 
	#END OF PASS-1----------------------------------------------------------	
	
	#----------------------------------------------------------
	# PASS-2:- Insert intermediate gates and stems in the 
	# output file by reading from the temp1 file and writing
	# in the temp2 file.
	#---------------------------------------------------------			
	my @sortedInterGates =  sort {
							my ($aa) = ($a =~ m/\d+\w+|\d+/);
							my ($bb) = ($b =~ m/\d+\w+|\d+/);
							$aa <=> $bb;
							} keys %intermediateOutputGates;		

	my @sortedStems =	sort {
						my ($aa) = ($a =~ m/\d+\w+|\d+/);
						my ($bb) = ($b =~ m/\d+\w+|\d+/);
						$aa <=> $bb;
						} keys %stems;			
	
	open(INPUT_FILE, "<tempfile1.txt"); #open the temp file for reading
	open(OUTPUT_FILE, ">tempfile2.txt"); #open another temp file for writing
	while (<INPUT_FILE>) {
		if ($_ =~ m/\}/ and $writeFlag == 0)
		{
			print OUTPUT_FILE "\t}\n";
			print OUTPUT_FILE "\t{node [shape=box fixedsize=1 width=0.15 height=0.15 label=\"\" style=filled color=black]\n";
			print OUTPUT_FILE "\t\t\t@sortedInterGates \n";
			print OUTPUT_FILE "\t}\n";
			
			print OUTPUT_FILE "\t{node [shape=point fixedsize=1 width=0.08 height=0.08]\n";
			print OUTPUT_FILE "\t\t\t@sortedStems \n";
			print OUTPUT_FILE "\t}\n";
			$writeFlag = 1;
		}
		else
		{	print OUTPUT_FILE $_;	}
	}
	#close  file handles
	close(OUTPUT_FILE);	
	close(INPUT_FILE);		
	unlink("tempfile1.txt"); #delete the temp file1.
	#END OF PASS-2-----------------------------------------
	
	#----------------------------------------------------------
	# PASS-3:- Insert intermediate gates and stems in the 
	# output file by reading from the temp2 file. This is
	# the final phase.
	#---------------------------------------------------------	
	open(INPUT_FILE, "<tempfile2.txt"); #open the temp file for reading
	open(OUTPUT_FILE, ">$outFile"); #open final output file for write, overwrite	
	
	while(<INPUT_FILE>)	{
		if ($_ =~ /\(/)	{
			my @gates   = ($_ =~ m/(\w+\d)/g);	
			my @gateNos = ($_ =~ m/\d+\w+|\d+/g);				
			#print "Gate Title = $gateTitle[0] \n";			
						
			for my $i (1..scalar @gates - 1) {									
				if (!(exists($stems{"stem$gates[$i]"}))) {
					if (grep $_ eq $gates[$i], @IOgates) {					
						print OUTPUT_FILE "\t$gates[$i]->$gates[0] [label=\"$gates[$i]\" color=$primaryIOColor penwidth=$penWidth]\n";
					}
					else  {
						print OUTPUT_FILE "\t$gates[$i]->$gates[0] [label=\"$gates[$i]\" color=$stuckAt0Clr]\n";						
					}
				}
				else {
					if (grep $_ eq $gateNos[$i], @insertedStems) { #check whether this stem is already inserted or not
						print OUTPUT_FILE "\t$stems{\"stem$gates[$i]\"}->$gates[0] [label=\"$gates[$i]->$gates[0]\" color=$stuckAt0Clr penwidth=$penWidth]\n";						
					}
					else {
						if (grep $_ eq $gates[$i], @IOgates) {
							print OUTPUT_FILE "\t$gates[$i]->$stems{\"stem$gates[$i]\"} [label=\"$gates[$i]\" color=$primaryIOColor penwidth=$penWidth]\n";							
						}
						else {
							print OUTPUT_FILE "\t$gates[$i]->$stems{\"stem$gates[$i]\"} [label=\"$gates[$i]\" color=$stuckAt0Clr penwidth=$penWidth]\n";							
						}
												
						print OUTPUT_FILE "\t$stems{\"stem$gates[$i]\"}->$gates[0] [label=\"$gates[$i]->$gates[0]\" color=$stuckAt0Clr penwidth=$penWidth]\n";						
						push(@insertedStems, $gateNos[$i]);
					}
				}
			}
		}
		else
		{	print OUTPUT_FILE $_;	}
	}	
	close(OUTPUT_FILE);	
	close(INPUT_FILE);		
	unlink("tempfile2.txt"); #delete the temp file2.
}
#-----------------------------------------------

sub computeStems {
	my $sourceList = $_[0];	
	
	my @gateList = ($sourceList =~ m/(\w+\d)/g);	
	my @gateNumbers = ($sourceList =~ m/\d+\w+|\d+/g);	
	
	# print "GATE LIST = @gateList \n";
	# print "GATE NUMBERS = @gateNumbers \n";	
	# $cin=getc(STDIN);
	
	for my $i(0..scalar @gateList - 1)	{			
		if (!(exists($intermediateOutputGates{$gateList[$i]}))) {
			if ($i==0) {
				$intermediateOutputGates{$gateList[$i]} = 0;	
			}
			else {
				$intermediateOutputGates{$gateList[$i]} = 1;	
			}			
		}
		else {
			$intermediateOutputGates{$gateList[$i]}++;
			if ($intermediateOutputGates{$gateList[$i]} >= 2) {	
				$stems{"stem$gateList[$i]"} = "stem$gateList[$i]";	
			}
		}
	}		
}


#-----------------------------------------------
#		Main Program
#-----------------------------------------------
$cwd = getcwd; #get Current Working Directory
$inputFile = $ARGV[0]; #Circuit Stats File

#-----------------------------------------------
#		Variables Initialization
#-----------------------------------------------
$numberOfPrimaryInputs = 0;
$numberOfPrimaryOutputs = 0;

$benchFile = $inputFile.".bench"; #Bench File to create circuits.
$outFile = $inputFile.".gv"; #Graphviz output file.


@IOgates = ();
%intermediateOutputGates = ();
%stems = ();
@insertedStems = ();

$outputStart = 0;	
$fontName = "georgia";
$bgColor = "gray84";
$edgeDirection = "right";
$primaryIOColor = "yellow";
$stuckAt0Clr = "red";
$penWidth = 1.5;
$fontSize = 11;

$flag = 0;
$writeFlag = 0;
$finalOutFormat = "pdf";
$outputFile = "$inputFile".".$finalOutFormat";
#-----------------------------------------------

open (INPUT_FILE, "$benchFile") or die $!;
createGraphFile(*INPUT_FILE);
close(INPUT_FILE);

print "\t---------------------------------------------------------------------\n";
print "\tOutput File = $outFile\n";
print "\tNumber of Primary Inputs = $numberOfPrimaryInputs \n";
print "\tNumber of Primary Outputs = $numberOfPrimaryOutputs \n";
print "\t------------------------------------------------------------------------\n";

my $start_time = [Time::HiRes::gettimeofday()];
#Convert the graph file to respective output format
qx(dot -T$finalOutFormat $outFile -o $outputFile);
my $run_time = Time::HiRes::tv_interval($start_time);
print "Time taken to draw the graph = $run_time \n";