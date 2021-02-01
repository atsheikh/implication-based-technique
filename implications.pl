#########################################################################################
# Description: 	This is the TASK 3 of PhD Thesis work. This task is based on 	 		#
#			   	finding and adding the implication relations between different			#
#				gates of the circuit.  Based only on stuck-at computation and 			#
#				implication path discovery.												#
#																						#
# USAGE: perl implications.pl [File Name]												#
#																						#
#																						#
# 																						#
# Author: Ahmad Tariq Sheikh.															#
#																						#
# LAST UPDATED: December 2, 2015														#
#																						#
#########################################################################################

#!/usr/bin/perl -w

# use warnings;
no warnings;
use Cwd;
use Time::HiRes;
use File::Basename;
use Data::Dumper qw(Dumper); 
use Storable qw(retrieve nstore dclone);
use Clone qw(clone);
use Sort::Naturally;
use List::MoreUtils qw(firstidx);
use Math::Combinatorics;
#-------------------------------------------------


sub intersect(\@\@) {
	my %e = map { $_ => undef } @{$_[0]};
	return grep { exists( $e{$_} ) } @{$_[1]};
}
#######################################################

sub union {
	my $A	=	$_[0];
	my $B	=	$_[1];
	
	my @namesA = ();
	my @namesB = ();
	
	my @pathCountA = ();
	my @pathCountB = ();
	
	# $A = "2_0-4_9-3_1";
	# $B = "2_1-4_7";
	# print "A = $A\n";
	# print "B = $B ==>UN\n";
	# $cin=getc(STDIN);	
	
	my @row1 = ();
	my @row2 = ();
	
	if ($A eq "0_0" and $B eq "0_0") {
		return "0_0";
	}
	elsif ($A eq "0_0" and $B ne "0_0") {
		return $B;
	}
	elsif ($A ne "0_0" and $B eq "0_0") {
		return $A;
	}
	
	if($A =~ m/-/) { # if this is true then the vector has more than one entries
		my @temp1 = split("-", $A);		
				
		foreach $k(@temp1) {
			@row1 = split(";", $k);
			push @namesA, $row1[0];
			push @pathCountA, $row1[1];
		}	
	}
	else {
		@row1 = split(";", $A);		
		push @namesA, $row1[0];
		push @pathCountA, $row1[1];	
	}
	
	if($B =~ m/-/) { # if this is true then the vector has more than one entries
		my @temp1 = split("-", $B);					
		
		foreach $k(@temp1) {
			@row2 = split(";", $k);
			push @namesB, $row2[0];
			push @pathCountB, $row2[1];
		}	
	}
	else {
		@row2 = split(";", $B);		
		push @namesB, $row2[0];
		push @pathCountB, $row2[1];		
	}
			
	my $un = ();
	my @common = ();
	#Compute Union
	foreach $k (0..scalar @namesA-1) {
		$idx = firstidx { $_ eq $namesA[$k] } @namesB ;

		if ($idx >= 0) {
			$un .= $namesA[$k].";".($pathCountA[$k] + $pathCountB[$idx])."-";
			push @common, $namesA[$k];
		}
		else {
			$un .= $namesA[$k].";".$pathCountA[$k]."-";
		}
	}
	
	# print "Common = @common\n";
	foreach $k (0..scalar @namesB-1) {
		if (!(grep {$_ eq $namesB[$k]} @common)) {			
			$un .= $namesB[$k].";".$pathCountB[$k]."-";
		}
	}
	
	# print "UN = $un \n"; exit;
	
	return $un;	
}
#######################################################

sub intersection {
	my $A	=	$_[0];
	my $B	=	$_[1];
	
	my @namesA = ();
	my @namesB = ();
	
	my @pathCountA = ();
	my @pathCountB = ();
	
	# $A = "2_0-5_9-3_1";
	# $B = "2_1-3_7-6_1";	
	# print "A = $A\n";
	# print "B = $B ==>IN\n";
	# $cin=getc(STDIN);
	
	my @row1 = ();
	my @row2 = ();
	
	if ($A eq "0_0" and $B eq "0_0") {
		return "0_0";
	}
	elsif ($A eq "0_0" and $B ne "0_0") {
		return "0_0";
	}
	elsif ($A ne "0_0" and $B eq "0_0") {
		return "0_0";
	}
	
	if($A =~ m/-/) { # if this is true then the vector has more than one entries
		my @temp1 = split("-", $A);		
				
		foreach $k(@temp1) {
			@row1 = split(";", $k);
			push @namesA, $row1[0];
			push @pathCountA, $row1[1];
		}	
	}
	else {
		@row1 = split(";", $A);		
		push @namesA, $row1[0];
		push @pathCountA, $row1[1];	
	}
	
	if($B =~ m/-/) { # if this is true then the vector has more than one entries
		my @temp1 = split("-", $B);					
		foreach $k(@temp1) {
			@row2 = split(";", $k);
			push @namesB, $row2[0];
			push @pathCountB, $row2[1];
		}	
	}
	else {
		@row2 = split(";", $B);		
		push @namesB, $row2[0];
		push @pathCountB, $row2[1];		
	}
	
	my $common = ();
	#Compute Intersection
	foreach $k (0..scalar @namesA-1) {
		$idx = firstidx { $_ eq $namesA[$k] } @namesB ;
		
		if ($idx >= 0) {
			$common .= $namesA[$k].";".($pathCountA[$k] + $pathCountB[$idx])."-";
		}		
	}
	
	if (!defined $common) {
		$common = "0_0";
	}
		
	# print "Common (RETURNED INTERSECTION FUNCTION) = $common \n";
	# $cin=getc(STDIN);
	# exit;	
	
	return $common;
}
#######################################################

sub difference {
	my $A	=	$_[0];
	my $B	=	$_[1];
	
	my @namesA = ();
	my @namesB = ();
	
	my @pathCountA = ();
	my @pathCountB = ();
	
	# $A = "2_0-5_9-3_1";
	# $B = "2_1-3_7-6_1";	
	# print "A = $A\n";
	# print "B = $B ==> DIFFERENCE\n";	
	
	my @row1 = ();
	my @row2 = ();
	
	if ($A eq "0_0" and $B eq "0_0") {
		return "0_0";
	}
	elsif ($A eq "0_0" and $B ne "0_0") {
		return $B;
	}
	elsif ($A ne "0_0" and $B eq "0_0") {
		return $A;
	}
	
	if($A =~ m/-/) { # if this is true then the vector has more than one entries
		my @temp1 = split("-", $A);		
				
		foreach $k(@temp1) {
			@row1 = split(";", $k);
			push @namesA, $row1[0];
			push @pathCountA, $row1[1];
		}	
	}
	else {
		@row1 = split(";", $A);		
		push @namesA, $row1[0];
		push @pathCountA, $row1[1];	
	}
	
	if($B =~ m/-/) { # if this is true then the vector has more than one entries
		my @temp1 = split("-", $B);					
		foreach $k(@temp1) {
			@row2 = split(";", $k);
			push @namesB, $row2[0];
			push @pathCountB, $row2[1];
		}	
	}
	else {
		@row2 = split(";", $B);		
		push @namesB, $row2[0];
		push @pathCountB, $row2[1];		
	}
	
	# print "Names A = @namesA, PCA = @pathCountA\n";
	# print "Names B = @namesB, PCB = @pathCountB\n";
	
	#Compute Difference
	my $diff = ();
	my @common = ();
	my $empty = 0;
	foreach $k (0..scalar @namesA-1) {
		$idx = firstidx { $_ eq $namesA[$k] } @namesB ;

		if ($idx >= 0) {
			if (abs($pathCountA[$k] - $pathCountB[$idx]) > 0) {				
				$diff .= $namesA[$k].";".(abs($pathCountA[$k] - $pathCountB[$idx]))."-";				
			}
			else {
				$empty++;
			}
			push @common, $namesA[$k];
		}
		else {
			$diff .= $namesA[$k].";".$pathCountA[$k]."-";
		}
	}
			
	foreach $k (0..scalar @namesB-1) {
		if (!(grep {$_ eq $namesB[$k]} @common)) {			
			$diff .= $namesB[$k].";".$pathCountB[$k]."-";
		}
	}
	
	#The following condition is valid if the difference of two sets is NULL 
	#or EMPTY SET.
	if ($empty == scalar @namesA and $empty == scalar @namesB) {
		$diff = "0_0";
	}
	
	return $diff;
}
#######################################################

sub mult {
	my $A = $_[0];
	my $k = $_[1];
	
	my @mult = ();
	my $mul = ();
	@temp = split("-", $A);
	
	foreach $l (@temp) {
		@temp1 = split(";", $l);
		push @mult, $temp1[0].";".($temp1[1]*$k);
	}
	$mul = join("-", @mult);	
	# print "Temp = @temp, MULT = $mul \n";
	
	return $mul;	
}
#######################################################

sub probUnion {
	my @inputs = @_;
		
	$union = 0;
	
	$mult = 1;
	foreach $k (@inputs) {
		$mult = $mult * (1-$k);
	}	
	
	$union = 1 - $mult;	
	
	# print "INS: @inputs\n"; 	
	# print "Union: $union\n";	
	# exit;
	
	return $union;
}
#######################################################

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}
#######################################################

sub readBenchFile {
	# print "\tReading $inputFile.bench file ... \n";
	# my $start_time = [Time::HiRes::gettimeofday()];
	
	$benchFile = "$inputFile.bench";
	
	open (INPUT_FILE, $benchFile) or die $!;
	
	$currentPO = ();
	$poIndexCounter = 0;
	my %tempCompleteGates = ();	
	%gateBelongings = (); 
	@primaryOutputs = ();
	@primaryInputs = ();
	@inter_IO_Gates = ();
	@allGates = ();
	@multiFanOuts = ();
	%poIndices = ();
	%inputs = ();
	%fanouts = ();
	%completeGates = ();
	%gatesCounter = ();
	%path = ();
		
	while(<INPUT_FILE>) {
		if ($_ =~ m/INPUT(.*)/) {		
			if ($1 =~ m/(\w+)/) {
				push (@primaryInputs, $1);	
			}
		}
		elsif ($_ =~ m/OUTPUT(.*)/) {
			if ($1 =~ m/(\w+)/) {
				push (@primaryOutputs, $1);					
			}
		}
		elsif ($_ =~ /#/ or $_ =~ /^\s/) {
			next;
		}		
		elsif ($_ =~ m/=/) {			
			
			my @gateList = ($_ =~ m/(\w+)/g);				
			$gateName[0] = $gateList[1];			
			@gateList = ($gateList[0], @gateList[2..$#gateList]);		
						
			# print "@gateList,  Length = ", scalar @gateList, ", GN: $gateName[0],  POINDEX: $poIndexCounter\n";			
			# $cin=getc(STDIN); exit;
			
			if (grep {$_ eq $gateList[0]} @primaryOutputs) {
				$currentPO = shift(@primaryOutputs);
				push @primaryOutputs, $currentPO;
				$poIndices{$gateList[0]} = $poIndexCounter;
			}
			else {
				$currentPO = $primaryOutputs[0];
			}
						
			$gateBelongings{$gateList[0]} = $currentPO;
			
			#---------------------------------------------------
			# Create an output to input and input to output MAP
			#---------------------------------------------------
			my $connections = ();
			for my $i (1..scalar @gateList-1) {				
				$connections .= "$gateList[$i]";	
				if ((scalar @gateList > 1) && ($i < scalar @gateList-1)) {
					$connections .= "-";
				}
				
				if (exists($fanouts{$gateList[$i]})) {				
					$temp = $fanouts{$gateList[$i]};
					$fanouts{$gateList[$i]} = $temp."-".$gateList[0];
				}
				else {
					$fanouts{$gateList[$i]} = $gateList[0];	
				}				
			}
			$inputs{$gateList[0]} = $gateName[0]."-".$connections;	

			# if ($gateName[0] eq "NOT") {
				# if (grep {$_ eq $connections} @primaryInputs) {
					# $invertedInputs = $gateList[0];
				# }
			# }			
			
			push @inter_IO_Gates, $gateList[0];				
			#-------------------------------------------------
			
			for my $i(0..scalar @gateList - 1) {			
				if (!(exists($tempCompleteGates{$gateList[$i]}))) {				
					if ($i == 0) {					
						$tempCompleteGates{$gateList[$i]} = 0;	
						$gatesCounter{$gateList[$i]} = 0;
						$completeGates{$gateList[$i]} = 0;	
					}
					else {					
						$tempCompleteGates{$gateList[$i]} = $gateList[0];	
						$gatesCounter{$gateList[$i]} = 1;
						$completeGates{$gateList[$i]} = "$gateName[0]-$gateList[0]";	
					}
				}
				else {				
					$gatesCounter{$gateList[$i]}++;										
					if ($gatesCounter{$gateList[$i]} >= 2) {							
						$tempCompleteGates{"$gateList[$i]->$gateList[0]"} = $gateList[0];
						$tempCompleteGates{"$gateList[$i]->$tempCompleteGates{$gateList[$i]}"} = $tempCompleteGates{$gateList[$i]};												
						$gatesCounter{"$gateList[$i]->$gateList[0]"} = 0;
						$gatesCounter{"$gateList[$i]->$tempCompleteGates{$gateList[$i]}"} = 0;						
						
						if ($completeGates{$gateList[$i]} eq 0) {
							$completeGates{"$gateList[$i]->$gateList[0]"} = "$gateName[0]-$gateList[0]";	
						}
						else {
							$completeGates{"$gateList[$i]->$gateList[0]"} = "$gateName[0]-$gateList[0]";						
							@previousLine = split('-', $completeGates{$gateList[$i]});							
							$completeGates{"$gateList[$i]->$previousLine[1]"} = "$previousLine[0]-$previousLine[1]";					
							$completeGates{$gateList[$i]} = 0;
						}
					}
					else {	
						$tempCompleteGates{$gateList[$i]} = $gateList[0];							
						$completeGates{$gateList[$i]} = "$gateName[0]-$gateList[0]";													
					}
				}
			}					
			$poIndexCounter++;
		}		
	}	
	close(INPUT_FILE);	
	
	
	
	####################################################
	# Fanout Counter
	####################################################
	foreach my $node (%fanouts) {	
		
		if (exists($fanouts{$node})) {		
			# print "Node = $node, Fanouts = $fanouts{$node} \n";
			@row = split("-", $fanouts{$node});
			$fanoutCounter{$node} = scalar @row;
			if ($fanoutCounter{$node} > 1) { # and ($node =~ m/g/)) {
				push @multiFanOuts, $node;
			}			
		}
	}
	
	
	# my $run_time = Time::HiRes::tv_interval($start_time);
	# print "\tTime taken Reading Bench file = $run_time sec.\n\n";	
	
	@allGates = @{ dclone(\@inter_IO_Gates) };	
	@inter_IO_Gates = nsort @inter_IO_Gates;	
}
#######################################################

sub readBenchFile_MEM_2_MEM {
		
	$currentPO = ();
	$poIndexCounter = 0;
	my %tempCompleteGates = ();	
	%gateBelongings = (); 
	@primaryOutputs = ();
	@primaryInputs = ();
	@inter_IO_Gates = ();
	@allGates = ();
	@multiFanOuts = ();
	%poIndices = ();
	%inputs = ();
	%fanouts = ();
	%completeGates = ();
	%gatesCounter = ();
	

	foreach (@circuit) {		
		if ($_ =~ m/INPUT(.*)/) {		
			if ($1 =~ m/(\w+)/) {
				push (@primaryInputs, $1);	
			}
		}
		elsif ($_ =~ m/OUTPUT(.*)/) {
			if ($1 =~ m/(\w+)/) {
				push (@primaryOutputs, $1);					
			}
		}
		elsif ($_ =~ /#/ or $_ =~ /^\s/) {
			next;
		}		
		elsif ($_ =~ m/=/) {			
					
			my @gateList = ($_ =~ m/(\w+)/g);				
			$gateName[0] = $gateList[1];			
			@gateList = ($gateList[0], @gateList[2..$#gateList]);
			
			# print "@gateList Length = ", scalar @gateList, ", @gateList, POINDEX: $poIndexCounter\n";			
			# $cin=getc(STDIN);
						
			if (grep {$_ eq $gateList[0]} @primaryOutputs) {
				$currentPO = shift(@primaryOutputs);
				push @primaryOutputs, $currentPO;
				$poIndices{$gateList[0]} = $poIndexCounter;
			}
			else {
				$currentPO = $primaryOutputs[0];
			}
						
			$gateBelongings{$gateList[0]} = $currentPO;
			
			#---------------------------------------------------
			# Create an output to input and input to output MAP
			#---------------------------------------------------
			my $connections;
			for my $i (1..scalar @gateList-1) {				
				$connections .= "$gateList[$i]";	
				if ((scalar @gateList > 1) && ($i < scalar @gateList-1)) {
					$connections .= "-";
				}
				
				if (exists($fanouts{$gateList[$i]})) {				
					$temp = $fanouts{$gateList[$i]};
					$fanouts{$gateList[$i]} = $temp."-".$gateList[0];
				}
				else {
					$fanouts{$gateList[$i]} = $gateList[0];	
				}				
			}
			$inputs{$gateList[0]} = $gateName[0]."-".$connections;	

			# if ($gateName[0] eq "NOT") {
				# if (grep {$_ eq $connections} @primaryInputs) {
					# $invertedInputs{$connections.":".$currentPO} = $gateList[0];
				# }
			# }
			
			push @inter_IO_Gates, $gateList[0];				
			#-------------------------------------------------
			
			for my $i(0..scalar @gateList - 1) {			
				if (!(exists($tempCompleteGates{$gateList[$i]}))) {				
					if ($i == 0) {					
						$tempCompleteGates{$gateList[$i]} = 0;	
						$gatesCounter{$gateList[$i]} = 0;
						$completeGates{$gateList[$i]} = 0;	
					}
					else {					
						$tempCompleteGates{$gateList[$i]} = $gateList[0];	
						$gatesCounter{$gateList[$i]} = 1;
						$completeGates{$gateList[$i]} = "$gateName[0]-$gateList[0]";	
					}
				}
				else {				
					$gatesCounter{$gateList[$i]}++;										
					if ($gatesCounter{$gateList[$i]} >= 2) {							
						$tempCompleteGates{"$gateList[$i]->$gateList[0]"} = $gateList[0];
						$tempCompleteGates{"$gateList[$i]->$tempCompleteGates{$gateList[$i]}"} = $tempCompleteGates{$gateList[$i]};												
						$gatesCounter{"$gateList[$i]->$gateList[0]"} = 0;
						$gatesCounter{"$gateList[$i]->$tempCompleteGates{$gateList[$i]}"} = 0;						
						
						if ($completeGates{$gateList[$i]} eq 0) {
							$completeGates{"$gateList[$i]->$gateList[0]"} = "$gateName[0]-$gateList[0]";	
						}
						else {
							$completeGates{"$gateList[$i]->$gateList[0]"} = "$gateName[0]-$gateList[0]";						
							@previousLine = split('-', $completeGates{$gateList[$i]});							
							$completeGates{"$gateList[$i]->$previousLine[1]"} = "$previousLine[0]-$previousLine[1]";					
							$completeGates{$gateList[$i]} = 0;
						}
					}
					else {	
						$tempCompleteGates{$gateList[$i]} = $gateList[0];							
						$completeGates{$gateList[$i]} = "$gateName[0]-$gateList[0]";													
					}
				}
			}					
			$poIndexCounter++;
		}		
	}		
	
	####################################################
	# Fanout Counter
	####################################################
	foreach my $node (%fanouts) {	
		
		if (exists($fanouts{$node})) {		
			# print "Node = $node, Fanouts = $fanouts{$node} \n";
			@row = split("-", $fanouts{$node});
			$fanoutCounter{$node} = scalar @row;
			if ($fanoutCounter{$node} > 1) { # and ($node =~ m/g/)) {
				push @multiFanOuts, $node;
			}			
		}
	}
	
	# my $run_time = Time::HiRes::tv_interval($start_time);
	# print "\tTime taken Reading Bench file = $run_time sec.\n\n";	
	
	@allGates = @{ dclone(\@inter_IO_Gates) };	
	@inter_IO_Gates = nsort @inter_IO_Gates;	
}
#######################################################

sub createBenchFileWithAllNetsAsOutputs {
	print "\tReading $benchFile file ... \n";
	# my $start_time = [Time::HiRes::gettimeofday()];
	
	open (OUT_FILE, ">$newFile") or die $!;
	
	open (INPUT_FILE, $benchFile) or die $!;
	
	print OUT_FILE "\n";
	foreach $k (0..scalar @primaryInputs - 1) {
		print OUT_FILE "INPUT($primaryInputs[$k])\n";
	}
	
	print OUT_FILE "\n";
	foreach $k (0..scalar @primaryOutputs - 1) {
		print OUT_FILE "OUTPUT($primaryOutputs[$k])\n";
	}
	
	print OUT_FILE "\n";
	foreach $k (0..scalar @inter_IO_Gates - 1) {
		$internalGates{$inter_IO_Gates[$k]} = 0; #initialize the internal gate output values
		if (grep {$_ eq $inter_IO_Gates[$k]} @primaryOutputs) {
			next;
		}
		else { #only print the internal gate outputs			
			print OUT_FILE "OUTPUT($inter_IO_Gates[$k])\n";			
		}
	}
	print OUT_FILE "\n";
	
	while(<INPUT_FILE>) {		
		if ($_ =~ m/=/) {
			print OUT_FILE $_;
		}			
	}	
	print OUT_FILE "\nEND";
	
	close(INPUT_FILE);		
	close(OUT_FILE);	
	
	system("dos2unix $newFile"); 
	
	# my $run_time = Time::HiRes::tv_interval($start_time);	
	# print "\tTime taken Reading Bench file = $run_time sec.\n\n";		
}
#######################################################

sub computeStatisticsFromFaultFile {		
	
	$file = $inputFile."-FO.fault";
	
	print "\tReading $file file ... \n";
	# my $start_time = [Time::HiRes::gettimeofday()];
	
	#	Initialize gateStatistics
	foreach $currentGate (@inter_IO_Gates) {
		$gateStatistics{$currentGate}{"0"} = 0;					
		$gateStatistics{$currentGate}{"1"} = 0;		
	}
	
	open (FILE, "$file") or die $!;		

	while (<FILE>) {
		chomp;
		if ($_ =~ m/\*/) {	
			$flag = 1;
			next;			
		}
		elsif($_ =~ m/Number of primary inputs(.*)/) {
			if ($1 =~ m/(\d+)/) 	{
				$numberOfPrimaryInputs = $1;
			}			
		}
		elsif($_ =~ m/Number of primary outputs(.*)/) {
			if ($1 =~ m/(\d+)/) 	{
				$numberOfPrimaryOutputs = $1;
			}			
		}
		elsif($_ =~ m/Number of combinational gates(.*)/) {
			if ($1 =~ m/(\d+)/) 	{
				$numberOfCombGates = $1;
			}			
		}
		elsif($_ =~ m/Number of flip-flops(.*)/) {
			if ($1 =~ m/(\d+)/) 	{
				$numberOfFF = $1;
			}			
		}
		elsif($_ =~ m/Level of the circuit(.*)/) {
			if ($1 =~ m/(\d+)/) 	{
				$numberOfLevels = $1;
			}			
		}
		elsif($_ =~ m/Number of test patterns applied(.*)/) {
			if ($1 =~ m/(\d+)/) 	{
				$numberOfTestVectors = $1;
			}			
		}
		elsif($_ =~ m/Number of collapsed faults(.*)/) {
			if ($1 =~ m/(\d+)/) 	{
				$numberOfCollapsedFaults = $1;
			}			
		}
		elsif($_ =~ m/Number of detected faults(.*)/) {
			if ($1 =~ m/(\d+)/) {
				$numberOfDetectedFaults = $1;
			}			
		}
		elsif($_ =~ m/Number of undetected faults(.*)/) {
			if ($1 =~ m/(\d+)/) {
				$numberOfUndetectedFaults = $1;				
			}			
		}
		elsif($_ =~ m/Fault coverage(.*)/) {
			if ($1 =~ m/(\d+\.\d+)/) {
				$faultCoverage = $1;
			}			
		}
		elsif (!$flag) {
			$row = [ split ];
			if (@$row[0] =~ m/test/) {					
				@currentInput =  split('', @$row[2]);
				@currentOutput = split('', @$row[3]);	

				# print "CI = @currentInput\nCO = @currentOutput \n"; 
				# $cin=getc(STDIN);
				################################################################################
				#Assign PO their respective values
				my $index = 0;
				foreach $value(@primaryOutputs) {
					$internalGates{$value} = $currentOutput[$index];
					$index++;
				}
								
				#Assign each intermediate output it's value from the @currentOutput vector						
				foreach $value (@inter_IO_Gates) {
					if (grep {$_ eq $value} @primaryOutputs) {
						next;
					}
					else {
						$internalGates{$value} = $currentOutput[$index];
						$index++;
					}
				}			
				
				#Assign PI their respective values
				$index=0;
				foreach $value(@primaryInputs) {
					$internalGates{$value} = $currentInput[$index];
					$index++;
				}
				# print Dumper \%internalGates;	exit;		
				
				################################################################################
												
				# For each gate process store and count its input pattern
				foreach $currentGate (@inter_IO_Gates) {
					if ($internalGates{$currentGate}==0) {
						$gateStatistics{$currentGate}{"0"} += 1;					
					}
					elsif ($internalGates{$currentGate}==1) {
						$gateStatistics{$currentGate}{"1"} += 1;											
					}					
				}
				
			}#end of output vectors evaluation
		} #end of last elsif on line 232		
	}#end of while input loop
	close(FILE);			
		
	#Average the gate statistics
	for $gate ( keys %gateStatistics ) {		
		for $vector ( keys %{ $gateStatistics{$gate} } ) {			
			$gateStatistics_averaged{$gate}{$vector} = $gateStatistics{$gate}{$vector}/$numberOfTestVectors;    			
		}
    }		
	
	foreach $in (@primaryInputs) {
		$gateStatistics_averaged{$in}{0} = 0.5;
		$gateStatistics_averaged{$in}{1} = 0.5;		
	}
	system ("del $inputFile-FO.bench");
	
	# my $run_time = Time::HiRes::tv_interval($start_time);
	# print  "\tTime taken Reading Faults file = $run_time sec.\n\n";		
}
#######################################################

sub findRFOL {

	my $inFile = $_[0];
	my $out = $_[1];
	
	my $flag=0; # the value of this flag is zero, except when all inputs are processed.
	my $fanoutIdentifier = 1;	
	$levelCounter = 0;
	##############################################
	# Find Fanouts in the current sub circuit.
	##############################################
	$iFile = $inFile."_".$out.".bench";
	
	# print "\n\tFile = $inFile, out = $out, FILE = $iFile \n\n";
	
	foreach $kk (@primaryInputs) {
		$gateLevel{$out}{$kk} = 1;
	}
	
	open (INPUT_FILE, $iFile) or die $!;
		
	while(<INPUT_FILE>) {
		if ($_ =~ m/=/) {						

			my @gateList = ($_ =~ m/(\w+)/g);				
			$gateName[0] = $gateList[1];			
			@gateList = ($gateList[0], @gateList[2..$#gateList]);	
			
			#---------------------------------------------------
			# Create an output to input and input to output MAP
			#---------------------------------------------------
			for my $i (1..scalar @gateList-1) {									
				if (exists($subCKTFanouts{$out}{$gateList[$i]})) {				
					$temp = $subCKTFanouts{$out}{$gateList[$i]};
					$subCKTFanouts{$out}{$gateList[$i]} = $temp."-".$gateList[0];
				}
				else {
					$subCKTFanouts{$out}{$gateList[$i]} = $gateList[0];	
				}
			}
		}
	}
			
	####################################################
	# Compute Sub Circuit Fanout Counter
	####################################################
	foreach $node (keys $subCKTFanouts{$out}) {			
		if (exists($subCKTFanouts{$out}{$node})) {		
			@row = split("-", $subCKTFanouts{$out}{$node});
			$subCKTFanoutCounter{$out}{$node} = scalar @row;
		}
	}
	#############################################
	
		
	#Step 2: Computer RC of each node i.e., number of inputs to each node in circuit
	my %RC = ();
	foreach $gate (keys $finalSUBCKT{$out}) {
		
		@inputs2CurrentGate = split('-', $inputs{$gate});				
		$RC{$out}{$gate} = scalar @inputs2CurrentGate-1;
	}
	# print Dumper \%RC; exit;
		
	#Step 3: Create NL
	my @NL = nsort keys $newInputs{$out};
	foreach $gate (@NL) {		
		$FOL{$out}{$gate} = "0_0";
	}
					
	while (scalar @NL > 0) {
	
		$levelCounter += 1;
		
		#Step 4: Make a DEEP COPY of @NL ARRAY
		my @CL = ();
		@CL = @{ dclone(\@NL) }; 
			
		#Step 5: Clear NL
		@NL = ();		
		
		#Step 6: Update RC of each gate
		if (!(grep {$_ eq $out} @CL)) {

			foreach $N1 (@CL) {			
				@out = split("-", $fanouts{$N1});	
				
				foreach $N2 (@out) {
					
					if (exists($RC{$out}{$N2})) {
									
						$RC{$out}{$N2} = $RC{$out}{$N2} - 1;						
						if ($RC{$out}{$N2}==0) {
							push @NL, $N2;							
							$gateLevel{$out}{$N2} = $levelCounter;
						}		
					}								
				}			
			}
		}	
		
		#Step 7: For every node in CL build its FOL and RFOL
		foreach $N (@CL) {
			
			#Build_FOLS method
			$RFOL{$out}{$N} = "0_0";
			$FOL{$out}{$N} = "0_0";
			
			if ($flag==0) {
				if ($subCKTFanoutCounter{$out}{$N} > 1) {
					$fanoutIdentifier	+=	1;
					$FOL{$out}{$N} = ($fanoutIdentifier).";0";
					$RFOL{$out}{$N} = ($fanoutIdentifier).";0";
					
					$FOLmap{$out}{$fanoutIdentifier} = $N;						
				}				
			}
			else {
				@inputs2N	=	split('-', $inputs{$N});
				@inputs2N	=	@inputs2N[1..$#inputs2N];
				
				$FOL{$out}{$N} = $FOL{$out}{$inputs2N[0]};
				
				foreach $k	(1..scalar @inputs2N-1) {
					# print "\nN: $N, IN: @inputs2N, FOL-$N: $FOL{$N}, RFOL-$N: $RFOL{$N}, FOL-$inputs2N[$k]: $FOL{$inputs2N[$k]}\n";
															
					$temp = intersection($FOL{$out}{$N}, $FOL{$out}{$inputs2N[$k]});
					$RFOL{$out}{$N}	=	union($RFOL{$out}{$N}, $temp);					
					$FOL{$out}{$N}	=	union($FOL{$out}{$N}, $FOL{$out}{$inputs2N[$k]});					
					# print "After UPDATE==> FOL-$N: $FOL{$N}, RFOL-$N: $RFOL{$N} \n";	
					# $cin=getc(STDIN);					
				}				
				
				#reduce_rfol(N) Method GOES HERE
				# $new_RFOL{$N} = "0_0";
				# while ($RFOL{$N} ne "0_0") {
					# @temp = split("-", $RFOL{$N});
					# @temp = sort @temp;
					
					# if (scalar @temp >= 1) {
						# # print "BEFORE UPDATE: RFOL-$N: $RFOL{$N}, FOL-$N: $FOL{$N}, Temp = @temp\n"; 
						
						# my @temp2 = split("_", $temp[$#temp]);
						# my $Y = $temp2[0];
						# my $k = $temp2[1];
						
						# $new_RFOL{$N} =  union($new_RFOL{$N}, $temp[$#temp]);															
						# $mul = mult($FOL{$FOLmap{$out}{$Y}}, $k);
						# $RFOL{$N} = difference($RFOL{$N}, $mul);
						
						# # print "AFTER UPDATE: RFOL-$N: $new_RFOL{$N}, FOL-$N: $FOL{$N}, Temp = @temp, $FOL{$FOLmap{$out}{$Y}}\n"; 
						# # print "Y: $Y, K = $k, MULT = $mul\n\n";						
						# # $cin=getc(STDIN);
						# # last;
					# }
					# else {
						# last;
					# }
				# }
				# $RFOL{$N} = $new_RFOL{$N};					
			}		
		}
		if ($flag==0)	{	$flag=1;	}
		
		#Step 8: Generate Unique identifier for the 
		if ($flag==1) {
			foreach $N (@CL) {
				if (exists($subCKTFanoutCounter{$out}{$N})) {
					if ($subCKTFanoutCounter{$out}{$N} > 1) {
						$fanoutIdentifier	+=	1;					
						$temp1 = ($fanoutIdentifier).";1";			
						$temp2 = $FOL{$out}{$N};
						$FOL{$out}{$N} = union($temp1, $temp2);
											
						$FOLmap{$out}{$fanoutIdentifier} = $N;						
					}				
				}
			}
		}			
	}
	
	foreach $key (keys %{$RFOL{$out}}) {
		if ($RFOL{$out}{$key} eq "0_0" or $key =~ m/v/) {
			delete $RFOL{$out}{$key};
		}
		#Final STEP: MAP Gates numbers to proper Gate Names in RFOL
		else {
			@temp = split("-", $RFOL{$out}{$key});
			my @final = ();		
			
			foreach $node (@temp) {
				@temp2 = split(";", $node);
				if ($temp2[1] != 0) {
					push @final, ($FOLmap{$out}{$temp2[0]}).";".$temp2[1];
				}
			}
			
			$RFOL{$out}{$key} = join("-", @final);
		}
	}
	foreach $key ( keys %{ $FOL{$out} } ) {
		if ($FOL{$out}{$key} eq "0_0" or $key =~ m/v/) {			
			delete $FOL{$out}{$key};
		}
		else {
			@temp = split("-", $FOL{$out}{$key});
			my @final = ();		
			
			foreach $node (@temp) {
				@temp2 = split(";", $node);
				if ($temp2[1] != 0) {
					push @final, ($FOLmap{$out}{$temp2[0]}).";".$temp2[1];
				}
			}
			
			$FOL{$out}{$key} = join("-", @final);
		}
	}
	close (INPUT_FILE);
	
	# print Data::Dumper->Dump( [ \%gateLevel ], [ qw(Gate_Levels) ] );
	# print Data::Dumper->Dump( [ \%FOLmap ], [ qw(FOL_MAP) ] );
	# print Data::Dumper->Dump( [ \%FOL ], [ qw(FOLS) ] ); exit;
	# print Data::Dumper->Dump( [ \%RFOL ], [ qw(RFOL) ] );	
	# $cin=getc(STDIN);	
	
}
#######################################################

sub findRFOL_FULL {

	my $flag=0; # the value of this flag is zero, except when all inputs are processed.
	my $fanoutIdentifier = 1;	
	$levelCounter = 0;
		
	foreach $kk (@primaryInputs) {
		$gateLevel{$kk} = 1;
	}	
			 
	#Step 2: Computer RC of each node i.e., number of inputs to each node in circuit
	my %RC = ();
	foreach $gate (keys %finalSUBCKT) {
		
		@inputs2CurrentGate = split('-', $inputs{$gate});				
		$RC{$gate} = scalar @inputs2CurrentGate-1;
	}
	
		
	#Step 3: Create NL i.e. LIST OF PRIMARY INPUTS FEEDING THE CIRCUIT
	my @NL = @{ dclone(\@primaryInputs) }; ;
	foreach $gate (@NL) {		
		$FOL{$gate} = "0_0";
	}
	
					
	while (scalar @NL > 0) {
	
		$levelCounter += 1;
		
		#Step 4: Make a DEEP COPY of @NL ARRAY
		my @CL = ();
		@CL = @{ dclone(\@NL) }; 
			
		#Step 5: Clear NL
		@NL = ();		
		
		#Step 6: Update RC of each gate
		foreach $N1 (@CL) {			
			@out = split("-", $fanouts{$N1});	
			
			foreach $N2 (@out) {
				
				if (exists($RC{$N2})) {
								
					$RC{$N2} = $RC{$N2} - 1;						
					if ($RC{$N2}==0) {
						push @NL, $N2;							
						$gateLevel{$N2} = $levelCounter;
					}		
				}								
			}			
		}
		
		#Step 7: For every node in CL build its FOL and RFOL
		foreach $N (@CL) {
			
			#Build_FOLS method
			$RFOL{$N} = "0_0";
			$FOL{$N} = "0_0";
			
			if ($flag==0) {
				if ($fanoutCounter{$N} > 1) {
					$fanoutIdentifier	+=	1;
					$FOL{$N} = ($fanoutIdentifier).";0";
					$RFOL{$N} = ($fanoutIdentifier).";0";
					
					$FOLmap{$fanoutIdentifier} = $N;						
				}				
			}
			else {
				@inputs2N	=	split('-', $inputs{$N});
				@inputs2N	=	@inputs2N[1..$#inputs2N];
				
				$FOL{$N} = $FOL{$inputs2N[0]};
				
				foreach $k	(1..scalar @inputs2N-1) {
					# print "\nN: $N, IN: @inputs2N, FOL-$N: $FOL{$N}, RFOL-$N: $RFOL{$N}, FOL-$inputs2N[$k]: $FOL{$inputs2N[$k]}\n";
															
					$temp = intersection($FOL{$N}, $FOL{$inputs2N[$k]});
					$RFOL{$N}	=	union($RFOL{$N}, $temp);					
					$FOL{$N}	=	union($FOL{$N}, $FOL{$inputs2N[$k]});					
					# print "After UPDATE==> FOL-$N: $FOL{$N}, RFOL-$N: $RFOL{$N} \n";	
					# $cin=getc(STDIN);					
				}				
				
				#reduce_rfol(N) Method GOES HERE
				# $new_RFOL{$N} = "0_0";
				# while ($RFOL{$N} ne "0_0") {
					# @temp = split("-", $RFOL{$N});
					# @temp = sort @temp;
					
					# if (scalar @temp >= 1) {
						# # print "BEFORE UPDATE: RFOL-$N: $RFOL{$N}, FOL-$N: $FOL{$N}, Temp = @temp\n"; 
						
						# my @temp2 = split("_", $temp[$#temp]);
						# my $Y = $temp2[0];
						# my $k = $temp2[1];
						
						# $new_RFOL{$N} =  union($new_RFOL{$N}, $temp[$#temp]);															
						# $mul = mult($FOL{$FOLmap{$out}{$Y}}, $k);
						# $RFOL{$N} = difference($RFOL{$N}, $mul);
						
						# # print "AFTER UPDATE: RFOL-$N: $new_RFOL{$N}, FOL-$N: $FOL{$N}, Temp = @temp, $FOL{$FOLmap{$out}{$Y}}\n"; 
						# # print "Y: $Y, K = $k, MULT = $mul\n\n";						
						# # $cin=getc(STDIN);
						# # last;
					# }
					# else {
						# last;
					# }
				# }
				# $RFOL{$N} = $new_RFOL{$N};					
			}		
		}
		if ($flag==0)	{	$flag=1;	}
		
		#Step 8: Generate Unique identifier for the 
		if ($flag==1) {
			foreach $N (@CL) {
				if (exists($fanoutCounter{$N})) {
					if ($fanoutCounter{$N} > 1) {
						$fanoutIdentifier	+=	1;					
						$temp1 = ($fanoutIdentifier).";1";			
						$temp2 = $FOL{$N};
						$FOL{$N} = union($temp1, $temp2);
											
						$FOLmap{$fanoutIdentifier} = $N;						
					}				
				}
			}
		}			
	}
	
	foreach $key ( keys %RFOL ) {
		if ($RFOL{$key} eq "0_0" or $key =~ m/v/) {
			delete $RFOL{$key};
		}
		#Final STEP: MAP Gates numbers to proper Gate Names in RFOL
		else {
			@temp = split("-", $RFOL{$key});
			my @final = ();		
			
			foreach $node (@temp) {
				@temp2 = split(";", $node);
				if ($temp2[1] != 0) {
					push @final, ($FOLmap{$temp2[0]}).";".$temp2[1];
				}
			}
			
			$RFOL{$key} = join("-", @final);
		}
	}
	foreach $key ( keys %FOL ) {
		if ($FOL{$key} eq "0_0" or $key =~ m/v/) {			
			delete $FOL{$key};
		}
		else {
			@temp = split("-", $FOL{$key});
			my @final = ();		
			
			foreach $node (@temp) {
				@temp2 = split(";", $node);
				if ($temp2[1] != 0) {
					push @final, ($FOLmap{$temp2[0]}).";".$temp2[1];
				}
			}
			
			$FOL{$key} = join("-", @final);
		}
	}

	
	# print Data::Dumper->Dump( [ \%gateLevel ], [ qw(Gate_Levels) ] );
	# print Data::Dumper->Dump( [ \%FOL ], [ qw(FOLS) ] ); exit;
	# print Data::Dumper->Dump( [ \%FOLmap ], [ qw(FOL_MAP) ] );	
	# print Data::Dumper->Dump( [ \%RFOL ], [ qw(RFOL) ] );	
	# $cin=getc(STDIN);	
	
}
#######################################################

sub extractSubCircuits_FULLCIRCUIT {
	
	%finalSUBCKT = ();
	
	print "\tReading $benchFile file ... \n";
	my $start_time = [Time::HiRes::gettimeofday()];
		
	open (OUT_FILE, ">$newFile") or die $!;
	
	open (INPUT_FILE, $benchFile) or die $!;
	
	print OUT_FILE "\n";
	
	foreach $k (nsort @primaryInputs) {
		print OUT_FILE "INPUT($k)\n";
		push @allOutputs, $k;
	}
	print OUT_FILE "\n";
	
	foreach $k (nsort @primaryOutputs) {
		print OUT_FILE "OUTPUT($k)\n";
		push @allOutputs, $k;
	}
	print OUT_FILE "\n";
	
	foreach $k (@inter_IO_Gates) {		
		if (grep {$_ eq $k} @primaryOutputs) {
			$finalSUBCKT{$k} = 1;
			next;
		}
		else { #only print the internal gate outputs			
			print OUT_FILE "OUTPUT($k)\n";						
			push @allOutputs, $k;
			$finalSUBCKT{$k} = 1;
		}
	}
	print OUT_FILE "\n";
	
	while(<INPUT_FILE>) {		
		if ($_ =~ m/=/) {			
			print OUT_FILE $_;
		}			
	}	
	print OUT_FILE "\nEND";
	
	close(INPUT_FILE);		
	close(OUT_FILE);	
	
	system("dos2unix $newFile"); 
	
	my $run_time = Time::HiRes::tv_interval($start_time);	
	print "\tTime taken Reading Bench file = $run_time sec.\n\n";	
	
	findRFOL_FULL();
	
	nstore \%FOL, $inputFile.'.FOL'; 
	nstore \%RFOL, $inputFile.'.RFOL'; 
	nstore \%gateLevel, $inputFile.'.level';
	
	open (OUT_FILE, ">$inputFile.lvl") or die $!;	
	print OUT_FILE Data::Dumper->Dump( [ \%gateLevel ], [ qw(GATE_LEVEL) ] );				
	close(OUT_FILE);
	
}
#######################################################

sub extractSubCircuits {
	
	%finalSUBCKT = ();
	%newInputs = ();
	%criticalNodesInCone = ();
	$inputsLimit = 100;
					
	$cg = "v";	
	# print Dumper \%highProbGates; exit;
			
	##################################################################
	# Scan from output all the way to the inputs to determine
	# number of primary inputs feeding the current logic cone.
	##################################################################
	my @nodesToProcess = ();
	my @nodesProcessed = ();
	
	foreach $currentPO ( @primaryOutputs ) {				
		
		@nodesToProcess = ();		
					
		if (!(exists($finalSUBCKT{$currentPO}{$currentPO}))) {
			$finalSUBCKT{$currentPO}{$currentPO} = 1;
		}
				
		@inputs2CurrentGate = split('-', $inputs{$currentPO});
		@inputs2CurrentGate = @inputs2CurrentGate[1..$#inputs2CurrentGate];
				
		foreach $in (@inputs2CurrentGate) {
			if (!(grep {$_ eq $in} @primaryOutputs) and !(grep {$_ eq $in} @primaryInputs)) {								
				push @nodesToProcess, $in;				
			}			
			else {							
				$newInputs{$currentPO}{$in} = 1;							
			}										
		}
		
		#	Check and compare the Prob. of 0 or 1 for each gate. 
		#	If it Prob. of 0 or 1 is higher than $probThreshold then mark it 
		#	and push it in %criticalNodesInCone.
		if ($highProbGates{$currentPO}{"0"} >= $probThreshold and $highProbGates{$currentPO}{"0"} >= $highProbGates{$currentPO}{"1"}) {
			$criticalNodesInCone{$currentPO}{$currentPO}{"high"} = 0;
			$criticalNodesInCone{$currentPO}{$currentPO}{"0"} = $highProbGates{$currentPO}{0};
		}
		elsif ($highProbGates{$currentPO}{"1"} >= $probThreshold) {
			$criticalNodesInCone{$currentPO}{$currentPO}{"high"} = 1;
			$criticalNodesInCone{$currentPO}{$currentPO}{"1"} = $highProbGates{$currentPO}{1};
		}
		
		if ($currentPO eq $cg) {
			print "PO: $currentPO, IN = @inputs2CurrentGate\n"; 		
			# print Dumper \%newInputs;
			print Dumper \%finalSUBCKT;
			print "Size: ",scalar(keys $finalSUBCKT{$currentPO}),";\n";
			print "INITIAL Nodes to Process: @nodesToProcess \n\n";		
			# exit;
		}		
		
		
		# Process each gate in the @nodesToProcess while it is not empty		
		while (scalar @nodesToProcess > 0) { 
												
			$currentGate = shift @nodesToProcess;			
			$finalSUBCKT{$currentPO}{$currentGate} = 1;
									
			#	Check and compare the Prob. of 0 or 1 for each gate. 
			#	If it Prob. of 0 or 1 is higher than $probThreshold then mark it 
			#	and push it in %criticalNodesInCone.
			if ($highProbGates{$currentGate}{"0"} >= $probThreshold and $highProbGates{$currentGate}{"0"} >= $highProbGates{$currentGate}{"1"}) {
				$criticalNodesInCone{$currentPO}{$currentGate}{"high"} = 0;
				$criticalNodesInCone{$currentPO}{$currentGate}{"0"} = $highProbGates{$currentGate}{0};
			}
			elsif ($highProbGates{$currentGate}{"1"} >= $probThreshold) {
				$criticalNodesInCone{$currentPO}{$currentGate}{"high"} = 1;
				$criticalNodesInCone{$currentPO}{$currentGate}{"1"} = $highProbGates{$currentGate}{1};
			}
			
			@inputs2CurrentGate = split('-', $inputs{$currentGate});
			@inputs2CurrentGate = @inputs2CurrentGate[1..$#inputs2CurrentGate];
			
			if ($currentPO eq $cg) {
				print "CG: $currentGate, Prob.(0,1): ($highProbGates{$currentGate}{0}, $highProbGates{$currentGate}{1})\n";
				print "Nodes to Process: @nodesToProcess, SIZE: ",scalar @nodesToProcess,"\n\n";
				print "INS: @inputs2CurrentGate \n";
				$cin=getc(STDIN);
			}
					
			foreach $in (@inputs2CurrentGate) {		
				
				if (!(grep {$_ eq $in} @primaryOutputs) and !(grep {$_ eq $in} @primaryInputs)) {										
					if (!(grep {$_ eq $in} @nodesToProcess)) {						
						push @nodesToProcess, $in;	
						$finalSUBCKT{$currentPO}{$in} = 1;
					}
				}
				else {						
					$newInputs{$currentPO}{$in} = 1;												
				}																		
			}		
		}	

		############################################################
		#	Print circuit
		############################################################
		# print "CPO = $currentPO\n"; $cin=getc(STDIN);	
		open (OUT, ">$inputFile"."_$currentPO.bench");
		
		print OUT "\n";
		print OUT "# $inputFile"."_$currentPO\n";
		print OUT "# ",scalar keys $newInputs{$currentPO}," inputs\n";
		print OUT "# 1 outputs\n\n";
		
		#write the inputs
		my @sorted_keys = nsort keys $newInputs{$currentPO};
		foreach $in ( @sorted_keys ) {	
			print OUT "INPUT($in)\n";		
		}
		print OUT "\n";
		#	print cirtical nodes
		# for $out (sort keys %{ $criticalNodesInCone{$currentPO} }) {
			# print OUT "OUTPUT($out)\n";		
		# }
		print OUT "OUTPUT($currentPO)\n";		
		print OUT "\n";
		
		for $gate (sort keys %{ $finalSUBCKT{$currentPO} } ) {
			@in = split("-", $inputs{$gate});
			print OUT "$gate = $in[0](";
			
			for ($ii = 1; $ii < scalar @in; $ii++) {					
				if ($ii  == scalar @in - 1)	
				{	print OUT "$in[$ii])\n";	}
				else
				{	print OUT "$in[$ii], ";	}											
			}		
		}	
		print OUT "\nEND\n";
		close (OUT);		
		system("dos2unix $inputFile"."_$currentPO.bench");		

		findRFOL($inputFile, $currentPO);		
		# print "$currentPO created ....\n";
		# $cin= getc(STDIN);
		
		############################################################
		#	If the number of inputs is > 20 then we have to extract
		#	a subcircuit that has # of inputs <= 20.
		############################################################
		if (keys $newInputs{$currentPO} > $inputsLimit) {
										
			@temp = split("_", $currentPO);
			$currentOutputNumber = $temp[1];
			$numberOfInputs = keys $newInputs{$currentPO};
			
			$start = 0;
			$end = $poIndices{$currentPO};
			if ($currentOutputNumber > 0) {
				$prevOut = $temp[0]."_".($currentOutputNumber-1);
				$start = $poIndices{$prevOut}+1;
			}
			@circ = @allGates[$start..$end];
			
			my @gatesToRemove = ();
			my @noFanoutInputs = ();
			my %terminalGates = ();
			my $tempNumInputs = $numberOfInputs;		
			
			
			#STEP-1: Find gates that have PIs terminating on them
			foreach $key ( keys %{ $newInputs{$currentPO} } ) {
				my @temp = split("-", $subCKTFanouts{$currentPO}{$key});
				if (scalar @temp == 1) {
					
					######################################################################
					# Find the terminal gate other than NOT gate of current PI				
					my $PI2GateName = (split("-", $inputs{$temp[0]}))[0];
					my $PI2Gate = $subCKTFanouts{$currentPO}{$key};
					
					# print "Key: $key, Temp = @temp, In-SIZE: $tempNumInputs, CG = $PI2GateName\n"; 
					# print "SUB: $PI2Gate\n";	
					# $cin=getc(STDIN);						
					
					while ($PI2GateName eq "NOT" and $PI2Gate !~ /-/) {
						
						my @t2 = split("-", $subCKTFanouts{$currentPO}{$PI2Gate});
						
						# print "T2 = @t2\n";
					
						$PI2GateName = (split("-", $inputs{$t2[0]}))[0];
						$PI2Gate = $subCKTFanouts{$currentPO}{$PI2Gate};
						
						# print "Key: $key, GN = $PI2GateName, Terminal Gate = $PI2Gate\n"; 
						# $cin=getc(STDIN);
					}
					
					$terminalGates{$PI2Gate} .= "$key-";										
					push @noFanoutInputs, $key;
					# $cin=getc(STDIN);											
				}			
				######################################################################
			}
			#Trim the %terminalGates Hash to include only gates with no multi fanouts
			foreach $k (keys %terminalGates) {
				my @temp = split("-", $terminalGates{$k});
				# print "Temp = @temp \n";  $cin=getc(STDIN);
				if ($k =~ m/-/ or scalar @temp == 1) {
					delete $terminalGates{$k};
				}					
			}			
			######################################################################	
			
			my @TG = ();
			#STEP 2: Find the Gates where PIs have reconvergent fanouts
			foreach $key ( keys %{ $RFOL{$currentPO} } ) {
				
				# Pick only the Primary Inpusts reconvergent fanouts
				if ($RFOL{$currentPO}{$key} !~ m/g/) {
					my @temp = split("-", $RFOL{$currentPO}{$key});														
					push @TG, "$key-$RFOL{$currentPO}{$key}";					
				}				
			}
			
		
			#--------------------------------------------------------------------------------
			#Foreach PI that is not converging at the terminal gate, check whether
			#it passes through it or not. If it passes then the cone remains intact,
			#otherwise we will delete the cone.
			#--------------------------------------------------------------------------------
			# print "-->TG = @TG \n";
			foreach $gate (@TG) {
				my @temp2 = split(/-|;/, $gate);
				
				# print "Temp = @temp2, @primaryOutputs\n";
				$terminalGate = $temp2[0];
				
				my @NP = ();
				my $tFlag = 0;
				my $poFlag = 0;
				foreach $k (@primaryInputs) {
					
					if ($tFlag == 1) {
						last;
					}
					
					if (!(grep {$_ eq $k} @temp2) and exists($subCKTFanouts{$currentPO}{$k})) {

						if ($subCKTFanouts{$currentPO}{$k} =~ m/-/) {
							@NP = split("-", $subCKTFanouts{$currentPO}{$k});				
							# print "Input: $k, NP: @NP, Terminal Gate = $terminalGate, $subCKTFanouts{$currentPO}{$k}\n"; 	$cin=getc(STDIN);
						}
						else {
							@NP = $subCKTFanouts{$currentPO}{$k};	
							# print "Input: $k, NP: @NP, Terminal Gate = $terminalGate, $subCKTFanouts{$currentPO}{$k}\n"; 	$cin=getc(STDIN);							
						}
						
						if ($poFlag == 1) {
							$poFlag = 0;							
						}
												
						$currentG = shift @NP;
						while ($tFlag == 0 and $poFlag == 0) { #grep {$_ ne $currentG} @primaryOutputs)  { 
							
							if ( $currentG eq $terminalGate ) {
								$tFlag = 1;
								last;
							}	
							elsif (grep {$_ eq $currentG} @primaryOutputs) {
								$poFlag = 1;
								last;								
							}
							
							push @NP, split("-", $subCKTFanouts{$currentPO}{$currentG});
							# print "NP: @NP, "; 
							
							$currentG = shift @NP;
													
							# print "Gate: $currentG, tFlag = $tFlag \n";
							# $cin=getc(STDIN);
							
						}						
					}				
				}
				if ($tFlag == 0) {
					my ($kk) = grep{ $terminalGates{$_} eq $RFOL{$currentPO}{$terminalGate} } keys %terminalGates;
					
					if (defined($kk)) {
						delete $terminalGates{$kk};
						$terminalGates{$terminalGate} = $RFOL{$currentPO}{$terminalGate};
					}
					else {
							$terminalGates{$terminalGate} = $RFOL{$currentPO}{$terminalGate};
					}				
				}
			}
			#-----------------------------------------------------------------------------------------------

			# print Dumper \%terminalGates;		
			# $cin=getc(STDIN);	
			
			# Delete the selected gates and their inputs
			foreach $node (sort keys %terminalGates) {
				# print "Node: $node, Level: $gateLevel{$currentPO}{$node}\n"; 
				
				if ($gateLevel{$currentPO}{$node} < 7 ) {
				$newInputs{$currentPO}{$node} = 1;
				delete $finalSUBCKT{$currentPO}{$node};
				
				#Start from the node all the way to the inputs and keep deleting the gates
				#encountered.
				my @NP = $inputs{$node};								
				
				# print "NP = @NP\n";
				# $cin=getc(STDIN);	
				
				while (scalar @NP > 0) {
				
					$currentG = shift @NP;
					# print "Current Gate = $currentG, NP = @NP\n";
					
					my @temp = split("-", $currentG);
					shift @temp;
					
					foreach $k (@temp) {						
						if (grep {$_ eq $k} @primaryInputs) {
							delete $newInputs{$currentPO}{$k};
							
							# print "Node: $node, Number of Inputs for Cone $currentPO = ", scalar keys $newInputs{$currentPO},"\n";
							
							if (scalar keys $newInputs{$currentPO} <= $inputsLimit) {	last;	}
						}
						else {
							delete $finalSUBCKT{$currentPO}{$k};
							push @NP, $inputs{$k};
						}
					}
					
					if (scalar keys $newInputs{$currentPO} <= $inputsLimit) {	last;	}
					# print "NP = @NP\n"; $cin=getc(STDIN);
				}				
				
				if (scalar keys $newInputs{$currentPO} <= $inputsLimit) {	last;	}
			}
			}
		}						
		# unlink ($inputFile."_".$currentPO.".bench"); 
		# $cin= getc(STDIN);		exit;
	}#END OF FOR LOOP	
		
	# print "==============================================================\n";
	# print Data::Dumper->Dump( [ \%inputSavings ], [ qw(Input_Savings) ] );
	# print Data::Dumper->Dump( [ \%RFOL ], [ qw(RFOL) ] );				
	# print Data::Dumper->Dump( [ \%newInputs ], [ qw(New_Inputs) ] );			
	
	
	############################################################
	# Final STEP: Create sub circuits in separate files.
	############################################################
	for $k (sort keys %finalSUBCKT) {
	# {
		# $k = "v23_0";
		open (OUT, ">$inputFile"."_$k.bench");
		
		print OUT "\n";
		print OUT "# $inputFile"."_$k\n";
		print OUT "# ",scalar keys $newInputs{$k}," inputs\n";
		print OUT "# 1 outputs\n\n";
		
		#write the inputs
		my @sorted_keys = nsort keys $newInputs{$k};
		foreach $in ( @sorted_keys ) {	
			print OUT "INPUT($in)\n";		
		}
		print OUT "\n";
					
		#	print cirtical nodes
		for $out ( sort keys %{ $criticalNodesInCone{$k} } ) {
			if (exists($finalSUBCKT{$k}{$out})) {
				print OUT "OUTPUT($out)\n";		
			}
		}
		# print OUT "OUTPUT($k)\n";		
		print OUT "\n";
		
		for $gate (sort keys %{ $finalSUBCKT{$k} } ) {
			@in = split("-", $inputs{$gate});
			print OUT "$gate = $in[0](";
			
			for ($ii = 1; $ii < scalar @in; $ii++) {					
				if ($ii  == scalar @in - 1)	
				{	print OUT "$in[$ii])\n";	}
				else
				{	print OUT "$in[$ii], ";	}											
			}		
		}	
		print OUT "\nEND\n";
		close (OUT);
		system("dos2unix $inputFile"."_$k.bench");
	}
	
	nstore \%FOL, $inputFile.'.FOL'; 
	nstore \%RFOL, $inputFile.'.RFOL'; 
	nstore \%gateLevel, $inputFile.'.level'
	
}
#######################################################

sub findImplicationsForExtractedCircuit_CONE_METHOD {

	%implications = ();
			
	#First simulate the sub circuits using HOPE
	for $PO (sort keys %finalSUBCKT) {
	
		$circ = $inputFile."_$PO.bench";
		$log = $inputFile."_$PO.log";
		$inputs = keys $newInputs{$PO};
		
		# print "circ: $circ, IN: $inputFile, IN: $inputs, log: $log\n"; 
		system("perl gen_rnd_vecs.pl $inputs $inputFile");
		system("hope -t $inputFile.test $circ -l $log"); 
								
		# print Dumper \%newInputs;
		@highProbGates1 = ();
		foreach $k1 (sort keys $newInputs{$PO}) {
			if (exists($newInputs{$PO}{$k1})) {
				push @highProbGates1, $k1;				
			}
		}
		foreach $k1 (sort keys $criticalNodesInCone{$PO}) {
			if (exists($finalSUBCKT{$PO}{$k1})) {
				push @highProbGates1, $k1;
			}
		}
		
		# print "$circ: HIGH: @highProbGates1 \n"; 
		# $cin=getc(STDIN);
		# exit;
		
		# Open the log file and perform the analysis				
		open (LOG_FILE, "$log") or die $!;	
		while (<LOG_FILE>){
			chomp;
			if ($_ !~ m/test/) {
				last;
			}
			$row = [ split ];
			
			$interOut = @$row[2].@$row[3];
			@interOut = split('', $interOut);
			
			# print "Inter OUT: @interOut \n"; $cin=getc(STDIN);exit;
									
			$index = 0;
			@CL = @{ dclone(\@interOut) }; 
			@HP = @{ dclone(\@highProbGates1) }; 
			
			foreach $gate (0..scalar @highProbGates1 - 1) {	
			
				#Further SPLIT @interOut b/w primary output values 
				#and the intermediate output values.					
				$targetOut = $interOut[$index];
				$targetWire = $highProbGates1[$gate];
				splice @interOut, $index, 1;
				splice @highProbGates1, $index, 1;
							
				# print "TGATE: $HP[$gate], TOUT = $targetOut, @$row[1] @interOut, Size = ", scalar @interOut,", lvl = $gateLevel{$PO}{$targetWire}\n"; 
				# print "Gates: @highProbGates1 \n";
				# $cin=getc(STDIN);
												
				#Process each value in interout
				foreach $out (0..scalar @interOut - 1) {	 
				
					$CG = $highProbGates1[$out];								
					
					if (($gateLevel{$PO}{$targetWire} > $gateLevel{$PO}{$CG}) && ($targetWire ne $CG)) 	{ 						
					# if ( ($targetWire ne $CG and !(grep {$_ eq $targetWire} @primaryInputs))  ) 	{ 						
						if ($interOut[$out]==0 and $targetOut==0) {	
							if (exists($implications{$targetWire}{$CG}{'0_0'})
								and (exists($implications{$targetWire}{$CG}{'0_1'}))) {
								$implications{$targetWire}{$CG}{'0_0'}=0;	
								$implications{$targetWire}{$CG}{'0_1'}=0;	
							}
							elsif (!(exists($implications{$targetWire}{$CG}{'0_0'}))
									and !(exists($implications{$targetWire}{$CG}{'0_1'}))) {
								$implications{$targetWire}{$CG}{'0_0'}=1;	
							}
							elsif (!(exists($implications{$targetWire}{$CG}{'0_0'}))
									and (exists($implications{$targetWire}{$CG}{'0_1'}))) {
								$implications{$targetWire}{$CG}{'0_0'}=0;
								$implications{$targetWire}{$CG}{'0_1'}=0;							
							}
							elsif (exists($implications{$targetWire}{$CG}{'0_0'})
									and !(exists($implications{$targetWire}{$CG}{'0_1'}))) {
								$implications{$targetWire}{$CG}{'0_0'}=1;	
							}
						}
						elsif ($interOut[$out]==0 and $targetOut==1) {					
							if (exists($implications{$targetWire}{$CG}{'0_1'})
								and (exists($implications{$targetWire}{$CG}{'0_0'}))) {						
								$implications{$targetWire}{$CG}{'0_0'}=0;	
								$implications{$targetWire}{$CG}{'0_1'}=0;	
							}
							elsif (!(exists($implications{$targetWire}{$CG}{'0_1'}))
									and !(exists($implications{$targetWire}{$CG}{'0_0'}))) {
								$implications{$targetWire}{$CG}{'0_1'}=1;	
							}
							elsif (!(exists($implications{$targetWire}{$CG}{'0_1'}))
									and (exists($implications{$targetWire}{$CG}{'0_0'}))) {
								$implications{$targetWire}{$CG}{'0_0'}=0;	
								$implications{$targetWire}{$CG}{'0_1'}=0;	
							}
							elsif (exists($implications{$targetWire}{$CG}{'0_1'})
									and !(exists($implications{$targetWire}{$CG}{'0_0'}))) {
								$implications{$targetWire}{$CG}{'0_1'}=1;	
							}
						}
						elsif ($interOut[$out]==1 and $targetOut==0) {					
							if (exists($implications{$targetWire}{$CG}{'1_0'})
								and (exists($implications{$targetWire}{$CG}{'1_1'}))) {						
								$implications{$targetWire}{$CG}{'1_0'}=0;	
								$implications{$targetWire}{$CG}{'1_1'}=0;	
							}
							elsif (!(exists($implications{$targetWire}{$CG}{'1_0'}))
									and !(exists($implications{$targetWire}{$CG}{'1_1'}))) {
								$implications{$targetWire}{$CG}{'1_0'}=1;							
							}
							elsif (!(exists($implications{$targetWire}{$CG}{'1_0'}))
									and (exists($implications{$targetWire}{$CG}{'1_1'}))) {
								$implications{$targetWire}{$CG}{'1_0'}=0;	
								$implications{$targetWire}{$CG}{'1_1'}=0;	
							}
							elsif (exists($implications{$targetWire}{$CG}{'1_0'})
									and !(exists($implications{$targetWire}{$CG}{'1_1'}))) {
								$implications{$targetWire}{$CG}{'1_0'}=1;	
							}
						}
						elsif ($interOut[$out]==1 and $targetOut==1) {					
							if (exists($implications{$targetWire}{$CG}{'1_0'})
								and (exists($implications{$targetWire}{$CG}{'1_1'}))) {						
								$implications{$targetWire}{$CG}{'1_0'}=0;	
								$implications{$targetWire}{$CG}{'1_1'}=0;	
							}
							elsif (!(exists($implications{$targetWire}{$CG}{'1_1'}))
									and !(exists($implications{$targetWire}{$CG}{'1_0'}))) {
								$implications{$targetWire}{$CG}{'1_1'}=1;	
							}
							elsif (!(exists($implications{$targetWire}{$CG}{'1_1'}))
									and (exists($implications{$targetWire}{$CG}{'1_0'}))) {
								$implications{$targetWire}{$CG}{'1_0'}=0;	
								$implications{$targetWire}{$CG}{'1_1'}=0;	
							}
							elsif (exists($implications{$targetWire}{$CG}{'1_1'})
									and !(exists($implications{$targetWire}{$CG}{'1_0'}))) {
								$implications{$targetWire}{$CG}{'1_1'}=1;	
							}
						}							
					}									 
				}
				$index += 1;
				@interOut = @{ dclone(\@CL) }; 
				@highProbGates1 = @{ dclone(\@HP) };
			}
		}		
		close(LOG_FILE);	
	}

	
	#Remove useless implications
	for $targetWire (sort keys %implications) {		
		for $CG (sort keys %{ $implications{$targetWire} }) {			
			# print "K: $PO, node=$node"; $cin=getc(STDIN);
			
			if (exists($implications{$targetWire}{$CG}{'0_0'}) and  ($implications{$targetWire}{$CG}{'0_0'}==0)) {
				delete $implications{$targetWire}{$CG}{'0_0'};					
			}
			if (exists($implications{$targetWire}{$CG}{'0_1'}) and  ($implications{$targetWire}{$CG}{'0_1'}==0)) {
				delete $implications{$targetWire}{$CG}{'0_1'};
			}
			if (exists($implications{$targetWire}{$CG}{'1_0'}) and  ($implications{$targetWire}{$CG}{'1_0'}==0)) {
				delete $implications{$targetWire}{$CG}{'1_0'};
			}
			if (exists($implications{$targetWire}{$CG}{'1_1'}) and  ($implications{$targetWire}{$CG}{'1_1'}==0)) {
				delete $implications{$targetWire}{$CG}{'1_1'};
			}	
				
			if ( scalar (keys %{ $implications{$targetWire}{$CG} }) < 1) {
				delete $implications{$targetWire}{$CG};
			}
			
		}
		if ( scalar (keys %{ $implications{$targetWire} }) < 1) {
				delete $implications{$targetWire};
		}
		
	}
	
	open (OUT_FILE, ">$inputFile.impEX") or die $!;	
	print OUT_FILE Data::Dumper->Dump( [ \%implications ], [ qw(IMPLICATIONS_EXHAUSTIVE) ] );		
	close(OUT_FILE);
	nstore \%implications, $inputFile.'.impX'; 
	
	open (OUT_FILE, ">$inputFile.crit") or die $!;	
	print OUT_FILE Data::Dumper->Dump( [ \%criticalNodesInCone ], [ qw(CRITICAL_NODES) ] );				
	close(OUT_FILE);
	
	open (OUT_FILE, ">$inputFile.lvl") or die $!;	
	print OUT_FILE Data::Dumper->Dump( [ \%gateLevel ], [ qw(GATE_LEVEL) ] );				
	close(OUT_FILE);
	
	# print Data::Dumper->Dump( [ \%path ], [ qw(PATH) ] );
}
#######################################################

sub findImplicationsForExtractedCircuit_FULLCIRCUIT {

	%implications = ();
	
	$circ = $inputFile."-FO.bench";
	$log = $inputFile."-FO.log";
	$inputs = scalar @primaryInputs;
	
	# print "circ: $circ, IN: $inputFile, IN: $inputs, log: $log\n"; 
	system("perl gen_rnd_vecs.pl $inputs $inputFile");
	system("hope -t $inputFile.test $circ -l $log"); 
					
	# Open the log file and perform the analysis				
	open (LOG_FILE, "$log") or die $!;	
	while (<LOG_FILE>){
		chomp;
		if ($_ !~ m/test/) {
			last;
		}
		$row = [ split ];
		
		$interOut = @$row[2].@$row[3];
		@interOut = split('', $interOut);
		
		# print "Inter OUT: @interOut \n"; $cin=getc(STDIN);exit;
								
		$index = 0;
		@CL = @{ dclone(\@interOut) }; 
		@HP = @{ dclone(\@allOutputs) }; 
		
		foreach $gate (0..scalar @allOutputs - 1) {	
		
			#Further SPLIT @interOut b/w primary output values 
			#and the intermediate output values.					
			$targetOut = $interOut[$index];
			$targetWire = $allOutputs[$gate];
			splice @interOut, $index, 1;
			splice @allOutputs, $index, 1;
						
			# print "TGATE: $HP[$gate], TOUT = $targetOut, @$row[1] @interOut, Size = ", scalar @interOut,", lvl = $gateLevel{$targetWire}\n"; 
			# print "Gates: @allOutputs \n";
			# $cin=getc(STDIN);
											
			#Process each value in interout
			foreach $out (0..scalar @interOut - 1) {	 
			
				$CG = $allOutputs[$out];								
				
				if ( ($gateLevel{$targetWire} > $gateLevel{$CG}) && ($targetWire ne $CG) and !(grep {$_ eq $targetWire} @primaryInputs) ) 	{ 
				# if ( ($targetWire ne $CG and !(grep {$_ eq $targetWire} @primaryInputs))  ) 	{ 
					if ($interOut[$out]==0 and $targetOut==0) {	
						if (exists($implications{$targetWire}{$CG}{'0_0'})
							and (exists($implications{$targetWire}{$CG}{'0_1'}))) {
							$implications{$targetWire}{$CG}{'0_0'}=0;	
							$implications{$targetWire}{$CG}{'0_1'}=0;	
						}
						elsif (!(exists($implications{$targetWire}{$CG}{'0_0'}))
								and !(exists($implications{$targetWire}{$CG}{'0_1'}))) {
							$implications{$targetWire}{$CG}{'0_0'}=1;	
						}
						elsif (!(exists($implications{$targetWire}{$CG}{'0_0'}))
								and (exists($implications{$targetWire}{$CG}{'0_1'}))) {
							$implications{$targetWire}{$CG}{'0_0'}=0;
							$implications{$targetWire}{$CG}{'0_1'}=0;							
						}
						elsif (exists($implications{$targetWire}{$CG}{'0_0'})
								and !(exists($implications{$targetWire}{$CG}{'0_1'}))) {
							$implications{$targetWire}{$CG}{'0_0'}=1;	
						}
					}
					elsif ($interOut[$out]==0 and $targetOut==1) {					
						if (exists($implications{$targetWire}{$CG}{'0_1'})
							and (exists($implications{$targetWire}{$CG}{'0_0'}))) {						
							$implications{$targetWire}{$CG}{'0_0'}=0;	
							$implications{$targetWire}{$CG}{'0_1'}=0;	
						}
						elsif (!(exists($implications{$targetWire}{$CG}{'0_1'}))
								and !(exists($implications{$targetWire}{$CG}{'0_0'}))) {
							$implications{$targetWire}{$CG}{'0_1'}=1;	
						}
						elsif (!(exists($implications{$targetWire}{$CG}{'0_1'}))
								and (exists($implications{$targetWire}{$CG}{'0_0'}))) {
							$implications{$targetWire}{$CG}{'0_0'}=0;	
							$implications{$targetWire}{$CG}{'0_1'}=0;	
						}
						elsif (exists($implications{$targetWire}{$CG}{'0_1'})
								and !(exists($implications{$targetWire}{$CG}{'0_0'}))) {
							$implications{$targetWire}{$CG}{'0_1'}=1;	
						}
					}
					elsif ($interOut[$out]==1 and $targetOut==0) {					
						if (exists($implications{$targetWire}{$CG}{'1_0'})
							and (exists($implications{$targetWire}{$CG}{'1_1'}))) {						
							$implications{$targetWire}{$CG}{'1_0'}=0;	
							$implications{$targetWire}{$CG}{'1_1'}=0;	
						}
						elsif (!(exists($implications{$targetWire}{$CG}{'1_0'}))
								and !(exists($implications{$targetWire}{$CG}{'1_1'}))) {
							$implications{$targetWire}{$CG}{'1_0'}=1;							
						}
						elsif (!(exists($implications{$targetWire}{$CG}{'1_0'}))
								and (exists($implications{$targetWire}{$CG}{'1_1'}))) {
							$implications{$targetWire}{$CG}{'1_0'}=0;	
							$implications{$targetWire}{$CG}{'1_1'}=0;	
						}
						elsif (exists($implications{$targetWire}{$CG}{'1_0'})
								and !(exists($implications{$targetWire}{$CG}{'1_1'}))) {
							$implications{$targetWire}{$CG}{'1_0'}=1;	
						}
					}
					elsif ($interOut[$out]==1 and $targetOut==1) {					
						if (exists($implications{$targetWire}{$CG}{'1_0'})
							and (exists($implications{$targetWire}{$CG}{'1_1'}))) {						
							$implications{$targetWire}{$CG}{'1_0'}=0;	
							$implications{$targetWire}{$CG}{'1_1'}=0;	
						}
						elsif (!(exists($implications{$targetWire}{$CG}{'1_1'}))
								and !(exists($implications{$targetWire}{$CG}{'1_0'}))) {
							$implications{$targetWire}{$CG}{'1_1'}=1;	
						}
						elsif (!(exists($implications{$targetWire}{$CG}{'1_1'}))
								and (exists($implications{$targetWire}{$CG}{'1_0'}))) {
							$implications{$targetWire}{$CG}{'1_0'}=0;	
							$implications{$targetWire}{$CG}{'1_1'}=0;	
						}
						elsif (exists($implications{$targetWire}{$CG}{'1_1'})
								and !(exists($implications{$targetWire}{$CG}{'1_0'}))) {
							$implications{$targetWire}{$CG}{'1_1'}=1;	
						}
					}							
				}									 
			}
			$index += 1;
			@interOut = @{ dclone(\@CL) }; 
			@allOutputs = @{ dclone(\@HP) };
		}
		# $cin=getc(STDIN);
	}		
	close(LOG_FILE);	
	

	
	#Remove useless implications
	for $targetWire (sort keys %implications) {		
		for $CG (sort keys %{ $implications{$targetWire} }) {			
			# print "K: node=$node"; $cin=getc(STDIN);
			
			if (exists($implications{$targetWire}{$CG}{'0_0'}) and  ($implications{$targetWire}{$CG}{'0_0'}==0)) {
				delete $implications{$targetWire}{$CG}{'0_0'};					
			}
			if (exists($implications{$targetWire}{$CG}{'0_1'}) and  ($implications{$targetWire}{$CG}{'0_1'}==0)) {
				delete $implications{$targetWire}{$CG}{'0_1'};
			}
			if (exists($implications{$targetWire}{$CG}{'1_0'}) and  ($implications{$targetWire}{$CG}{'1_0'}==0)) {
				delete $implications{$targetWire}{$CG}{'1_0'};
			}
			if (exists($implications{$targetWire}{$CG}{'1_1'}) and  ($implications{$targetWire}{$CG}{'1_1'}==0)) {
				delete $implications{$targetWire}{$CG}{'1_1'};
			}	
				
			if ( scalar (keys %{ $implications{$targetWire}{$CG} }) < 1) {
				delete $implications{$targetWire}{$CG};
			}
			
		}
		if ( scalar (keys %{ $implications{$targetWire} }) < 1) {
				delete $implications{$targetWire};
		}
		
	}
	
	open (OUT_FILE, ">$inputFile.impEX") or die $!;	
	print OUT_FILE Data::Dumper->Dump( [ \%implications ], [ qw(IMPLICATIONS_EXHAUSTIVE) ] );		
	close(OUT_FILE);
	nstore \%implications, $inputFile.'.impX'; 
	
	# open (OUT_FILE, ">$inputFile.lvl") or die $!;	
	# print OUT_FILE Data::Dumper->Dump( [ \%gateLevel ], [ qw(GATE_LEVEL) ] );				
	# close(OUT_FILE);
	
	# print Data::Dumper->Dump( [ \%path ], [ qw(PATH) ] );
}
#######################################################

sub pathFinder {
	my $source = $_[0];
	my $target = $_[1];
	my $flag = $_[2];
		
	# $flag = 0;
	my $globalPathCounter = 1;
	my $localPathCounter = 1;
	my $paths2PO = 0;
	my $currentPath  = 0;
	my @PC = ();

	if ($source eq $target or grep  {$_ eq $source} @primaryOutputs) {
		return;
	}
			
	if (!(exists($path{$source}))) {
					
		$path{$source}{$globalPathCounter} = $source;					
		if ($fanouts{$source} =~ m/-/) {
			@outputs4mCurrentGate = split('-', $fanouts{$source});		
		}
		else {
			@outputs4mCurrentGate = $fanouts{$source};
		}
		
		$paths2PO = scalar @outputs4mCurrentGate;
		
				
		if ($flag==1){
			print "\n===>Source: $source, Target: $target\n"; 		
			print "Outputs: @outputs4mCurrentGate\n";			
			print "Paths to PO: $paths2PO\n";			
			$cin=getc(STDIN); 
		}

		$currentPath = $localPathCounter;
				
		foreach $out (@outputs4mCurrentGate) {
			
			$path{$source}{$currentPath} .= "-".$out;							
			
			if ($flag==1){print "==Taking Path: $out\n";}
			
			if (!(grep {$_ eq $out} @primaryOutputs)) {
				while ($localPathCounter != 0) {
													
					if ($fanouts{$out} =~ m/-/) {
						
						unshift @outputs, split('-', $fanouts{$out});	
						my @temp = split('-', $fanouts{$out});		
						
						foreach $k (($globalPathCounter+1)..($globalPathCounter + scalar @temp - 1)) {
							unshift @PC, $k;												
							$path{$source}{$k} = $path{$source}{$currentPath};
						}
						
						$localPathCounter += scalar @temp - 1;
						$paths2PO += scalar @temp - 1;	
						$globalPathCounter += scalar @temp - 1;
						
						if ($flag==1){
							print Dumper \%path;
							print "..OUTPUTS: @outputs, CP: $currentPath, LPC: $localPathCounter, GPC: $globalPathCounter, PARRAY: @PC\n";
							print "OUTPUTS b4 Shift: @outputs\n"; 
							$cin=getc(STDIN);	
						}
					}
					else {
						unshift @outputs, $fanouts{$out};					
						if ($flag==1){ 
							print "$out, OUTPUTS b4 Shift: @outputs\n"; 
							$cin=getc(STDIN); 
						}						
					}				
					
					$out = shift(@outputs);			
					$path{$source}{$currentPath} .= "-".$out;
																			
					if ($flag==1){
						print ">>OUT: $out, OUTPUTS: @outputs, CP: $currentPath, LPC: $localPathCounter, GPC: $globalPathCounter, PARRAY: @PC\n";
						print "PATH: $path{$source}{$currentPath}\n\n";
						$cin=getc(STDIN); 
					}
					
					if ( (grep {$_ eq $out} @primaryOutputs) ) {					
																								
						$localPathCounter -= 1;
						
						if (scalar @outputs > 0) {
							
							$out = shift(@outputs);	
							$currentPath = shift @PC;
							
							if ($flag==1) {
								print ".OUTPUTS: @outputs, OUT: $out, LPC: $localPathCounter, GPC: $globalPathCounter, CP: $currentPath\n";
								print $path{$source}{$currentPath};
								$cin=getc(STDIN);
							}
							
							while (grep {$_ eq $out} @primaryOutputs) {
																
								$localPathCounter -= 1;								
																								
								if (scalar @outputs == 0) {
									last;
								}
								else {
									$path{$source}{$currentPath} .= "-".$out;	
									# print "$path{$source}{$currentPath}, $currentPath\n";	
									# print "\n";
									
									$out = shift(@outputs);	
									$currentPath = shift @PC;
								}
								
								if ($flag==1){
									print "....OUTPUTS: @outputs, OUT: $out, LPC: $localPathCounter, GPC: $globalPathCounter, CP: $currentPath\n";
									print "$path{$source}{$currentPath}, $currentPath\n";	
									# $cin=getc(STDIN);
								}
							}
							if (defined($out)) {								
								# $currentPath = shift @PC;						
								$path{$source}{$currentPath} .= "-".$out;								
							}
						}					
					}					
					if ($flag==1){
						print Dumper \%path;
					}
				}					
			}			
				
			$globalPathCounter++;
			$localPathCounter = 1;
			$currentPath = $globalPathCounter;
			if ($globalPathCounter <= $paths2PO) {
				$path{$source}{$currentPath} = $source;		
			}	
			if ($flag==1){ print "CP: $currentPath, LPC: $localPathCounter, GPC: $globalPathCounter, PARRAY: @PC\n\n";}
		}
	}
}
#######################################################

sub getExcitationProbability {

	$gate = $_[0];
	$source = $_[1];
	$gateType = $_[2];
	$imp = $_[3];	
		
	$P_excitation = 0;
	$currentPE = 0;
			
	@insToProcess = ();
	@ins = split("-", $inputs{$gate});
	shift @ins;
	
	# print "GATE: $gate, S: $source, GT: $gateType\n";
	
	foreach $k (@ins) {
		# print "K: $k \n";
		if ($gateType eq "NOT" and $k eq $source) {
			$exc{$gate} = 0.5;
			return $P_excitation;
		}
		if ($k eq $source) {
			next;
		}
		if (grep {$_ eq $k} @primaryInputs) {
			push @insToProcess, $k;
			$gatesOPP{$k}{"0"} = 0.5;
			$gatesOPP{$k}{"1"} = 0.5;
		}
		else {
			push @insToProcess, $k;
		}
	}
	
	if (scalar @insToProcess == 0) {
		$P_excitation = 0.5;			
		return $P_excitation;
	}		
	
	# print "\n\tINS: @ins, INS 2 PROCESS: @insToProcess, IMP-VALUE: $imp, SOURCE: $source\n\n";	
	
	################################################################################################
	# COMPUTE THE UNION OF OUTPUT PROBABILITIES.
	################################################################################################
	
	if ($imp==0 and $gateType eq "NOR") {							
		@ins = ();
		foreach $k (@insToProcess) {
			if (exists($exc{$k})) {
				push @ins, $exc{$k};
			}
			else {
				push @ins, $gatesOPP{$k}{"1"};
			}			
		}
		$currentPE = probUnion(@ins);		
	}
	
	elsif ($imp==0 and $gateType eq "OR") {						
		$currentPE = 1;
		foreach $k (@insToProcess) {
			if (exists($exc{$k})) {
				$currentPE *= $exc{$k};
			}
			else {
				$currentPE *=  $gatesOPP{$k}{"0"};
			}
		}						
	}
	
	elsif ($imp==0 and $gateType eq "NAND") {
		$currentPE = 1;
		foreach $k (@insToProcess) {
			if (exists($exc{$k})) {
				$currentPE *= $exc{$k};
			}
			else {
				$currentPE *=  $gatesOPP{$k}{"1"};
			}
		}		
	}
	
	elsif ($imp==0 and $gateType eq "AND") {
		@ins = ();
		foreach $k (@insToProcess) {
			if (exists($exc{$k})) {
				push @ins, $exc{$k};
			}
			else {
				push @ins, $gatesOPP{$k}{"0"};
			}			
		}
		$currentPE = probUnion(@ins);				
	}
	
	elsif ($imp==1 and $gateType eq "NOR") {
		$currentPE = 1;
		foreach $k (@insToProcess) {
			if (exists($exc{$k})) {
				$currentPE *= $exc{$k};
			}
			else {
				$currentPE *=  $gatesOPP{$k}{"0"};
			}
		}			
	}
	
	if ($imp==1 and $gateType eq "OR") {
		@ins = ();
		foreach $k (@insToProcess) {
			if (exists($exc{$k})) {
				push @ins, $exc{$k};
			}
			else {
				push @ins, $gatesOPP{$k}{"1"};
			}			
		}
		
		$currentPE = probUnion(@ins);			
	}	
	
	elsif ($imp==1 and $gateType eq "NAND") {
		@ins = ();
		foreach $k (@insToProcess) {
			if (exists($exc{$k})) {
				push @ins, $exc{$k};
			}
			else {
				push @ins, $gatesOPP{$k}{"0"};
			}			
		}
		$currentPE = probUnion(@ins);				
	}
	
	elsif ($imp==1 and $gateType eq "AND") {		
		$currentPE = 1;
		foreach $k (@insToProcess) {
			if (exists($exc{$k})) {
				$currentPE *= $exc{$k};
			}
			else {
				$currentPE *=  $gatesOPP{$k}{"1"};
			}
		}					
	}
	################################################################################################
	
	$P_excitation = $currentPE;	
	################################################################################################	
				
	return $P_excitation;		
}
#######################################################

sub stuckAtDue2Implication {
	my $source 	=	$_[0];
	my $target 	=	$_[1];
	my $implication = $_[2];
	my $flag = 		$_[3];
					
	%circuitFaults_TEMP_0 = ();
	%circuitFaults_TEMP_1 = ();
	
	%circuitFaults_TEMP_0 = %{ clone (\%circuitFaults_0) };	
	%circuitFaults_TEMP_1 = %{ clone (\%circuitFaults_1) };	
	%implications_TEMP = %{ clone (\%implications) };		
	%inputs_TEMP =  %{ clone (\%inputs) };
	%fanouts_TEMP =  %{ clone (\%fanouts) };		
	
	%impSATs = ();
	%exc = ();
	%foTemp = ();	
	%outPropStatus = ();
	%path = ();
		
	my $sourceImp = (split("_", $implication))[0];
	my $targetImp = (split("_", $implication))[1];
	
	my $sourceGateType = (split("-", $inputs_TEMP{$source}))[0];
	my $targetGateType = (split("-", $inputs_TEMP{$target}))[0];	
			
	$area = 0;		
	$newTarget = $target;
	$newSource = $source;
		
	####################################################################
	# COMPUTE AREA OVERHEAD DUE TO IMPLICATION WIRE ADDED
	####################################################################	
	$targetGateChangedFlag = 0;
	$maskingGateChangedFlag = 0;
	$maskingGate = 0;
	$maskingGateType = 0;

	$maskingGateType = (split("-", $inputs_TEMP{$fanouts_TEMP{$target}}))[0];							
	$maskingGate = (split("-", $fanouts_TEMP{$target}))[0];	
	
			
	if ($implication eq "0_0") {			
	
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NAND" or $maskingGateType eq "AND")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs_TEMP{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.
		if ($maskingGateChangedFlag==1) {		
			$area = $origArea + ($nmosDrainArea + $pmosDrainArea);
			
			if ($maskingGateType eq "NOT") {				
				$inputs_TEMP{$maskingGate} = "NAND-$target-$source";							
			}
			elsif ($maskingGateType eq "NAND" or $maskingGateType eq "AND") {				
				$inputs_TEMP{$maskingGate} .= "-$source";			
			}
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NOR" or $maskingGateType eq "OR") {								
			$area = $origArea + (2*$nmosDrainArea + 2*$pmosDrainArea);		
			
			if ($targetGateType eq "NOT") {	
				
				$input2TargetGate = (split("-", $inputs_TEMP{$target}))[1];															
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} = "NOR-$input2TargetGate-$in2NOT";
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;
				}
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";				
					$inputs_TEMP{$target} = "NOR-$input2TargetGate-IMP_TEMP1";
					
					$circuitFaults_TEMP_0{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
						else {					
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
					}
					else {														
						$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$source};
					}
				}
			}
			
			elsif ($targetGateType eq "NOR") {	
			
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} .= "-$in2NOT";
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;
				}
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} .= "-IMP_TEMP1";	

					$circuitFaults_TEMP_0{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
						else {					
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
					}
					else {						
						$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$source};				
					}
				}
			}
		
			elsif ($targetGateType eq "AND") {							
				$inputs_TEMP{$target} .= "-$source";					
			}			
			elsif ($targetGateType eq "NAND") {	
				
				$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
				$inputs_TEMP{$target} .= "-IMP_TEMP1";		
								
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
			elsif ($targetGateType eq "OR") {							
				$inputs_TEMP{$target} .= "-$source";
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}			
		}						
	}	
	
	elsif ($implication eq "0_1") {	
		
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NOR" or $maskingGateType eq "OR")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs_TEMP{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
			
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.
		if ($maskingGateChangedFlag==1) {
			$area = $origArea + (2*$nmosDrainArea + 2*$pmosDrainArea);	
			
			if ($maskingGateType eq "NOT") {
			
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$maskingGate} = "NOR-$target-$in2NOT";	
					$newSource = $in2NOT;	
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {					
						
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";				
					$inputs_TEMP{$maskingGate} = "NOR-$target-IMP_TEMP1";	

					$circuitFaults_TEMP_0{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
						else {					
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
					}
					else {					
						$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$source};
					}
				}
			}
			
			elsif ($maskingGateType eq "NOR" or $maskingGateType eq "OR") {		
			
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$maskingGate} .= "-$in2NOT";	
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$maskingGate} .= "-IMP_TEMP1";	

					$circuitFaults_TEMP_0{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
						else {					
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
					}
					else {					
						$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$source};				
					}
				}
			}			
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NAND" or $maskingGateType eq "AND") {			
			
			$area = $origArea + ($nmosDrainArea + $pmosDrainArea);
			
			if ($targetGateType eq "NOT") {			
				$input2TargetGate = (split("-", $inputs_TEMP{$target}))[1];															
				$inputs_TEMP{$target} = "NAND-$input2TargetGate-$source";		
			}
		
			elsif ($targetGateType eq "NAND") {			
				$inputs_TEMP{$target} .= "-$source";				
			}
			
			elsif ($targetGateType eq "OR" ) {			
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} .= "-$in2NOT";
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;					
				}				
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} .= "-IMP_TEMP1";		

					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;

					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {						
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};				
					}				
				}
			}
		
			elsif ($targetGateType eq "NOR") {							
				$inputs_TEMP{$target} .= "-$source";
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
			elsif ($targetGateType eq "AND") {	
				
				$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
				$inputs_TEMP{$target} .= "-IMP_TEMP1";		
								
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
		}						
	}
	
	elsif ($implication eq "1_0") {	
		
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NAND" or $maskingGateType eq "AND")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs_TEMP{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.
		if ($maskingGateChangedFlag==1) {
			
			$area = $origArea + (2*$nmosDrainArea + 2*$pmosDrainArea);
			
			if ($maskingGateType eq "NOT") {	
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$maskingGate} = "NAND-$target-$in2NOT";
					$newSource = $in2NOT;	
					$sourceImp = ($sourceImp+1)%2;
				}
				else {			
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";				
					$inputs_TEMP{$maskingGate} = "NAND-$target-IMP_TEMP1";	
					
					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {								
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};
					}
				}
			}
		
			elsif ($maskingGateType eq "NAND" or $maskingGateType eq "AND") {	
			
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$maskingGate} .= "-$in2NOT";		
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {	
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$maskingGate} .= "-IMP_TEMP1";		

					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {						
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};				
					}
				}
			}
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NOR" or $maskingGateType eq "OR") {			
			
			$area = $origArea + ($nmosDrainArea + $pmosDrainArea);
			
			if ($targetGateType eq "NOT") {							
				$input2TargetGate = (split("-", $inputs_TEMP{$target}))[1];				
				$inputs_TEMP{$target} = "NOR-$input2TargetGate-$source";								
			}
			
			elsif ($targetGateType eq "NOR") {			
				$inputs_TEMP{$target} .= "-$source";			
			}
			
			elsif ($targetGateType eq "AND") {	
			
				if ($sourceGateType eq "NOT") {
					
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} .= "-$in2NOT";
					$newSource = $in2NOT;	
					$sourceImp = ($sourceImp+1)%2;
				}				
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} .= "-IMP_TEMP1";		

					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;

					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {						
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};				
					}				
				}
			}			
			elsif ($targetGateType eq "NAND") {							
				$inputs_TEMP{$target} .= "-$source";
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
			elsif ($targetGateType eq "OR") {	
				
				$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
				$inputs_TEMP{$target} .= "-IMP_TEMP1";		
								
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
		}	
	}
		
	elsif ($implication eq "1_1") {	
		
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NOR" or $maskingGateType eq "OR")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs_TEMP{$newTarget}))[0];
		}
		
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.				
		if ($maskingGateChangedFlag==1) {			
			$area = $origArea + ($nmosDrainArea + $pmosDrainArea);	
			
			if ($maskingGateType eq "NOT") {
				$inputs_TEMP{$maskingGate} = "NOR-$target-$source";		
			}
			elsif ($maskingGateType eq "NOR" or $maskingGateType eq "OR") {
				$inputs_TEMP{$maskingGate} .= "-$source";			
			}
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NAND" or $maskingGateType eq "AND") {	
			$area = $origArea + (2*$nmosDrainArea + 2*$pmosDrainArea);		
						
			if ($targetGateType eq "NOT") {			
			
				$input2TargetGate = (split("-", $inputs_TEMP{$target}))[1];					
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} = "NAND-$input2TargetGate-$in2NOT";	
					$newSource = $in2NOT;	
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {				
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} = "NAND-$input2TargetGate-IMP_TEMP1";	

					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {					
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};
					}
				}
			}		
			
			elsif ($targetGateType eq "NAND") {
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} .= "-$in2NOT";	
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {					
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} .= "-IMP_TEMP1";
						
					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;
				
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {					
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};
					}
				}
			}
			
			elsif ($targetGateType eq "OR") {							
				$inputs_TEMP{$target} .= "-$source";					
			}
						
			elsif ($targetGateType eq "NOR") {	
				
				$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
				$inputs_TEMP{$target} .= "-IMP_TEMP1";		
								
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
			elsif ($targetGateType eq "AND") {							
				$inputs_TEMP{$target} .= "-$source";
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
		}						
	}			
	####################################################################	
			
	if ($flag==1) {
		print "\n-----------------------------------------------------------------------------------------------------------------------------------\n\n";
		print "==>SOURCE: $source ($sourceGateType, P$sourceImp: $gatesOPP{$source}{$sourceImp}), N-S: $newSource, A-T: $target ($targetGateType), N-T: $newTarget, M-G: $maskingGate($maskingGateType, $maskingGateChangedFlag), IMP: $implication, T-FLAG: $targetGateChangedFlag, Area: $area, FO-S: $fanoutCounter{$newSource}, GL-S: ",$gateLevel{$newSource},", GL-T: ",$gateLevel{$target},"\n"; 
	}
		
	###################################################
	# IF SOURCE IS DIRECTLY FEEDING THE TARGET THEN 
	# NO NEED TO COMPUTE STUCK-AT.
	###################################################
	@ins = split("-", $inputs{$newTarget});
	# print "INS: @ins \n"; exit;
	if (grep {$_ eq $newSource} @ins) {
		return ($currentSAT, 0);
	}	
	if ($newSource eq $newTarget) {		
		return ($currentSAT, 0);
	}
	###################################################
	

	$implicationType{"$newSource:$newTarget"} = 0;			
		
	if( $newTarget eq $target ) {		
		$reachability{$source.":".$target} = 0;		
		$reachability{$newSource.":".$target} = 0;		
	}
	else {
		$reachability{$source.":".$target} = 0;		
		$reachability{$source.":".$newTarget} = 0;	
		$reachability{$source.":".$target} = 0;		
		$reachability{$newSource.":".$newTarget} = 0;			
	}
	
	###########################################################################
	# COMPUTE REACHABLE PATHS FROM SOURCE GATE TO THE TARGET
	###########################################################################
	pathFinder($newSource, $newTarget, 0);
						
	$foTemp{$newSource} = 1;
	foreach $key (sort keys %{ $path{$newSource} }) {													
		$foTemp{$newSource} += 1;													
	}
	###########################################################################
		
	#------------------------------------------------------------------------------
	#Check the paths for the existence of TARGET gate in DIRECT PATH.	
	#------------------------------------------------------------------------------
	@processQ = ();
		
	$counter = 0;
	$movingImp = $sourceImp;
	$currentPathImp = $sourceImp;
	
	@outs = split("-", $fanouts{$newSource});
	foreach $out (@outs) {
		push @processQ, $out
	}
	
	if ($sourceImp==0) {
		$outPropStatus{$newSource} = "P0";
	}
	
	elsif ($sourceImp==1) {
		$outPropStatus{$newSource} = "P1";
	}	
		
	while (scalar @processQ != 0) {
	
		$currentGate = shift @processQ;
		
		@ins = split("-", $inputs{$currentGate});	
		$gateType = shift @ins;
		$numOfInputs = scalar @ins;
		
		if ($flag==1) {
			print "\nCG: $currentGate, Type: $gateType, CPI: $currentPathImp, INS: @ins, # of ins: $numOfInputs\n"; 						
		}
		
		# Process Each input of the current gate
		@inWiresStatus = ();
		foreach $in (@ins) {
			if (exists($outPropStatus{$in})) {
				push @inWiresStatus, $outPropStatus{$in};
			}			
		}
		
		# print "@inWiresStatus \n"; 
		# print Dumper \%outPropStatus;
		
		############################################################################
		# UPDATE PATH GATES THAT DRIVE THE IMPLICATION
		############################################################################
		if ($gateType eq "NOT") {
			
			if (grep {$_ eq "P0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P1";
			}
			elsif (grep {$_ eq "P1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P0";
			}			
			elsif (grep {$_ eq "NP0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}			
			elsif (grep {$_ eq "NP1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP0";
			}			
			
			$currentPathImp = ($currentPathImp+1)%2;							
		}
		
		elsif ($gateType eq "NAND") {
			
			if (grep {$_ eq "P0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P1";
			}			
			elsif ( (@inWiresStatus == grep { $_ eq "P1" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
				$outPropStatus{$currentGate} = "P0";
			}
			elsif (grep {$_ eq "NP0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}					
			elsif (@inWiresStatus == grep { $_ eq "NP1" } @inWiresStatus)  {
				$outPropStatus{$currentGate} = "NP0";
			}
			else {
				$outPropStatus{$currentGate} = "NP0";
			}			
			
			$currentPathImp = ($currentPathImp+1)%2;							
		}
		
		elsif ($gateType eq "AND") {
		
			if (grep {$_ eq "P0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P0";
			}			
			elsif ( (@inWiresStatus == grep { $_ eq "P1" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
				$outPropStatus{$currentGate} = "P1";
			}
			elsif (grep {$_ eq "NP0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP0";
			}			
			elsif (@inWiresStatus == grep { $_ eq "NP1" } @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}				
			else {
				$outPropStatus{$currentGate} = "NP1";
			}						
		}
		
		elsif ($gateType eq "NOR") {				
		
			if (grep {$_ eq "P1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P0";
			}			
			elsif ( (@inWiresStatus == grep { $_ eq "P0" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
				$outPropStatus{$currentGate} = "P1";
			}
			elsif (grep {$_ eq "NP1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP0";
			}			
			elsif (@inWiresStatus == grep { $_ eq "NP0" } @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}	
			elsif (grep {$_ eq "P0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}
			else {
				$outPropStatus{$currentGate} = "NP1";
			}						
						
			$currentPathImp = ($currentPathImp+1)%2;
		}								
				
		elsif ($gateType eq "OR") {							
									
			if (grep {$_ eq "P1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P1";
			}			
			elsif ( (@inWiresStatus == grep { $_ eq "P0" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
				$outPropStatus{$currentGate} = "P0";
			}
			elsif (grep {$_ eq "NP1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}			
			elsif (@inWiresStatus == grep { $_ eq "NP0" } @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP0";
			}			
			else {
				$outPropStatus{$currentGate} = "NP0";
			}						
		}
		
								
		@outs = split("-", $fanouts{$currentGate});
		foreach $out (@outs) {
			if (!(grep{$_ eq $out} @processQ) and !(grep({$_ eq $out} @primaryOutputs)) ) {
				push @processQ, $out;
			}
		}
		
		
		###########################################################################
		# COMPUTE REACHABLE PATHS FROM CURRENT GATE TO THE TARGET
		###########################################################################
		$reachability{$currentGate.":".$newTarget} = 0;
		pathFinder($currentGate, $newTarget, 0);			
						
		$foTemp{$currentGate} = 1;
		foreach $key (sort keys %{ $path{$currentGate} }) {													
			$foTemp{$currentGate} += 1;
			if (exists($path{$currentGate}{$key})) {	
			
				# $implicationType{"$newSource:$newTarget"} = "D";
				# $implicationType{"$newSource:$target"} = "D";
			
				if ($path{$currentGate}{$key} =~ /\b$newTarget\b/) {
					$reachability{$currentGate.":".$newTarget} += 1;								
				}
			}
		}					
		###########################################################################
		
		if ($flag==1) {
			print "\nCG: $currentGate, Type: $gateType, Area = $area, FO: $foTemp{$currentGate}, R-$newTarget: ",$reachability{$currentGate.":".$newTarget},", Path-Type: ",$implicationType{"$newSource:$newTarget"},"\n"; 								
			# print "ProcessQ: @processQ\n";
		}		
	}				
			

	# print Dumper \%outPropStatus; 
	
	#------------------------------------------------------------------------------
	# DIRECT PATH DISCOVERY FINISHED HERE
	#------------------------------------------------------------------------------
	
	# if ($implicationType{"$newSource:$newTarget"} ne "D") {
		# $implicationType{"$newSource:$newTarget"} = "I";
		# $implicationType{"$newSource:$target"} = "I";
	# }
	# print Dumper \%outPropStatus;
	#------------------------------------------------------------------------------
	#If there is no forward path between the SOURCE and the TARGET, then we have to 
	#iterate backwards to find the common lowest level stem that has both SOURCE and 
	#TARGET gate in its path. PHEW... :(
	#------------------------------------------------------------------------------
	# $flag = 1;
	# print "S: $source, T: $target, SOURCE FOL: $FOL{$source}, TARGET FOL: $FOL{$target}, IMP: $implication, I-PATH: $indirectPath\n";		
		
	my @folCommon = split(/[-;]/, intersection($FOL{$newSource}, $FOL{$newTarget}));
			
	@comm = ();
	@pathGates = ();
	
	foreach $k (@folCommon) {
		if ($k =~ m/\D/ and $k ne $newSource) {
			push @comm, $k;
		}				
	}
	@folCommon = @{ dclone(\@comm) };	
	@folCommon =  nsort @folCommon;
				
	if ($flag==1) {
		print "\n--COMMON: @folCommon\n";   
		# $cin=getc(STDIN);	
	}
	
	if (scalar @folCommon==1 and $folCommon[0] eq "0_0") {
		@folCommon = ();
	}
	
	foreach $src (@folCommon) {
		
		if ($src =~ m/\D/) {						
			pathFinder($src, $newTarget, 0);					
			my $targetFound = 0;	
			my $sourceFound = 0;										

			#Compute the implication polarity at current source by iterating
			#from current common SRC to the actual implication source and counting
			#the number of inverters.
			$newSourceImp = $sourceImp;
			foreach $key (sort keys %{ $path{$src} }) {								
				if (exists($path{$src}{$key})) {
					if ($path{$src}{$key} =~ /\b$newSource\b/ and $sourceFound==0) {
						my @temp = ();
						
						if ($path{$src}{$key} =~ m/-/) {
							@temp = split ("-", $path{$src}{$key});
						}
						else {
							push @temp, $path{$src}{$key};
						}
																																		
						$counter = 0;							
						while ($temp[$counter] ne $newSource) {
						
							$counter++;
							@t = split("-", $inputs_TEMP{$temp[$counter]});
							$gateType = shift @t;									
						
							if ($gateType eq "NOT" or $gateType eq "NAND" or $gateType eq "NOR") {								
								$newSourceImp = ($newSourceImp+1)%2;
							}							
						}
						$sourceFound++;	
					}
				}
			}				
			
			if ($flag==1) {
				print "\n--STARTING NODE: $src, NEW SOURCE-IMP: $newSourceImp\n"; 			
				# print Dumper $path{$src};				
				# $cin=getc(STDIN);	exit;
			}					
			
			#Check the paths for the existence of TARGET gate.							
			@processQ = ();
												
			$movingImp = $newSourceImp;				
			$currentPathImp = $newSourceImp;

			@outs = split("-", $fanouts{$src});
			foreach $out (@outs) {
				if ($out ne $newSource) {
					push @processQ, $out;
				}
			}
			
			if ($newSourceImp==0) {
				$outPropStatus{$src} = "P0";
			}
			elsif ($newSourceImp==1) {
				$outPropStatus{$src} = "P1";
			}
			
			while (scalar @processQ != 0) {
	
				$currentGate = shift @processQ;
				
				@ins = split("-", $inputs{$currentGate});	
				$gateType = shift @ins;
				$numOfInputs = scalar @ins;
				
				if ($flag==1) {
					print "\nCG: $currentGate, Type: $gateType, CPI: $currentPathImp, INS: @ins, # of ins: $numOfInputs\n"; 						
				}
				
				# Process Each input of the current gate
				@inWiresStatus = ();
				foreach $in (@ins) {
					if (exists($outPropStatus{$in})) {
						push @inWiresStatus, $outPropStatus{$in};
					}			
				}
				
				# print "IN: @inWiresStatus \n"; 
				# print Dumper \%outPropStatus;
				
				############################################################################
				# UPDATE PATH GATES THAT DRIVE THE IMPLICATION
				############################################################################
				if ($gateType eq "NOT") {
					
					if (grep {$_ eq "P0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P1";
					}
					elsif (grep {$_ eq "P1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P0";
					}			
					elsif (grep {$_ eq "NP0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}			
					elsif (grep {$_ eq "NP1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP0";
					}			
					
					$currentPathImp = ($currentPathImp+1)%2;							
				}
				
				elsif ($gateType eq "NAND") {
					
					if (grep {$_ eq "P0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P1";
					}			
					elsif ( (@inWiresStatus == grep { $_ eq "P1" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
						$outPropStatus{$currentGate} = "P0";
					}
					elsif (grep {$_ eq "NP0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}					
					elsif (@inWiresStatus == grep { $_ eq "NP1" } @inWiresStatus)  {
						$outPropStatus{$currentGate} = "NP0";
					}
					else {
						$outPropStatus{$currentGate} = "NP0";
					}			
					
					$currentPathImp = ($currentPathImp+1)%2;							
				}
				
				elsif ($gateType eq "AND") {
				
					if (grep {$_ eq "P0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P0";
					}			
					elsif ( (@inWiresStatus == grep { $_ eq "P1" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
						$outPropStatus{$currentGate} = "P1";
					}
					elsif (grep {$_ eq "NP0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP0";
					}			
					elsif (@inWiresStatus == grep { $_ eq "NP1" } @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}				
					else {
						$outPropStatus{$currentGate} = "NP1";
					}						
				}
				
				elsif ($gateType eq "NOR") {				
				
					if (grep {$_ eq "P1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P0";
					}			
					elsif ( (@inWiresStatus == grep { $_ eq "P0" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
						$outPropStatus{$currentGate} = "P1";
					}
					elsif (grep {$_ eq "NP1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP0";
					}			
					elsif (@inWiresStatus == grep { $_ eq "NP0" } @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}	
					elsif (grep {$_ eq "P0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}
					else {
						$outPropStatus{$currentGate} = "NP1";
					}						
								
					$currentPathImp = ($currentPathImp+1)%2;
				}								
						
				elsif ($gateType eq "OR") {							
											
					if (grep {$_ eq "P1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P1";
					}			
					elsif ( (@inWiresStatus == grep { $_ eq "P0" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
						$outPropStatus{$currentGate} = "P0";
					}
					elsif (grep {$_ eq "NP1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}			
					elsif (@inWiresStatus == grep { $_ eq "NP0" } @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP0";
					}			
					else {
						$outPropStatus{$currentGate} = "NP0";
					}						
				}
				
							
				@outs = split("-", $fanouts{$currentGate});
				foreach $out (@outs) {
					if ( !(grep{$_ eq $out} @processQ) ) {
						push @processQ, $out;
					}
				}				
				############################################################################
				
				###########################################################################
				# COMPUTE REACHABLE PATHS FROM CURRENT GATE TO THE TARGET
				###########################################################################
				$reachability{$currentGate.":".$newTarget} = 0;
				pathFinder($currentGate, $newTarget, 0);					
								
				$foTemp{$currentGate} = 1;
				foreach $key (sort keys %{ $path{$currentGate} }) {													
					$foTemp{$currentGate} += 1;
					if (exists($path{$currentGate}{$key})) {		
						if ($path{$currentGate}{$key} =~ /\b$newTarget\b/) {
							$reachability{$currentGate.":".$newTarget} += 1;								
						}
					}
				}											
				###########################################################################	
				
				if ($flag==1) {
					print "\nCG: $currentGate, Type: $gateType, Area = $area, FO: $foTemp{$currentGate}, R-$newTarget: ",$reachability{$currentGate.":".$newTarget},", Path-Type: D\n"; 								
					print "ProcessQ: @processQ\n";
				}			
			}	
		}
	}		

	#------------------------------------------------------------------------------
	# INDIRECT PATH DISCOVERY FINISHED HERE
	#------------------------------------------------------------------------------
					
	#-------------------------------------------------------------------
	# TRAVERSE BACKWARDS TO CONSTRUCT THE FINAL PATH GATES
	#-------------------------------------------------------------------
	my @processQ = ();
	my @sensQ = ();		
	my %movingImp = ();
	
		
	push @processQ, $newTarget; 	
	
	# print "processQ: @processQ \n";
	
	while (scalar @processQ != 0) {
		
		$currentGate = shift @processQ;
		
		if ($currentGate eq $newSource) {
			$movingImp{$currentGate} = ($outPropStatus{$currentGate} =~ m/\d/)[0];
			push @sensQ, $currentGate;					
			next;
		}
		
		# PROCESS INPUTS OF CURRENT GATE
		@ins = split("-", $inputs{$currentGate});
		$currentGateType = shift @ins;
		$numOfInputs = scalar @ins;
		
		# print "CG: $currentGate, $currentGateType, INS: @ins, # of ins: $numOfInputs\n";
		@insStatus = ();
		@inStatusGates = ();		
				
		foreach $in (@ins) {
			if (exists($outPropStatus{$in})) {				
				push @insStatus, $outPropStatus{$in};
				push @inStatusGates, $in;
			}			
		}			
		
		# print "insStatus: @insStatus, @inStatusGates\n"; 		
		
		if (scalar @inStatusGates == 0) {
			$movingImp{$currentGate} = ($outPropStatus{$currentGate} =~ m/\d/)[0];
			push @sensQ, $currentGate;
			next;			
		}
		
		###############################################################
		# RULES ARE ADDED HERE TO CONSTRUCT THE FINAL PATH GATES
		###############################################################
		if ($currentGateType eq "NOT") {
			
			push @sensQ, $currentGate;			
			push @processQ, @inStatusGates;

			$inStat = shift @insStatus;
			
			if ($inStat eq "P0" or $inStat eq "NP0") {
				$movingImp{$currentGate} = 1;
			}
			elsif ($inStat eq "P1" or $inStat eq "NP1") {
				$movingImp{$currentGate} = 0;
			}
		}
	
		elsif ($currentGateType eq "NAND") {
									
			if (grep { $_ eq "P0" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P0's or NP0's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "P0") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 1;				
				}
			}
			
			if (grep { $_ eq "NP0" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P0's or NP0's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "NP0") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 1;				
				}
			}

			elsif ( (@insStatus == grep { $_ eq "P1" } @insStatus)  ) {	
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 0;
			}			
			
			# elsif (grep { $_ eq "NP0" } @insStatus) {
				
				# push @sensQ, $currentGate; 
				# $movingImp{$currentGate} = 1;					
								
				# foreach $kk (0..scalar @insStatus) {
					
					# $wire = $inStatusGates[$kk];
					# $wireStatus = $insStatus[$kk];
					
					# if ($wireStatus eq "NP0") {						
						# push @processQ, $wire;							
					# }
				# }				
			# }			
		
			elsif ( (@insStatus == grep { $_ eq "NP1" } @insStatus) and ($numOfInputs==scalar @insStatus) ) {
				
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 0;
			}
						
		}
		
		elsif ($currentGateType eq "AND") {
			
			if (grep { $_ eq "P0" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P0's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "P0") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 0;					
				}
			}			
					
			
			if (grep { $_ eq "NP0" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P0's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "NP0") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 0;					
				}
			}			
			
			
			elsif ( (@insStatus == grep { $_ eq "P1" } @insStatus)  ) {	
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 1;
			}
			
			
			# elsif (grep { $_ eq "NP0" } @insStatus) {
			
				# push @sensQ, $currentGate; 				
				# $movingImp{$currentGate} = 0;
												
				# foreach $kk (0..scalar @insStatus) {
					
					# $wire = $inStatusGates[$kk];
					# $wireStatus = $insStatus[$kk];
					
					# if ($wireStatus eq "NP0") {						
						# push @processQ, $wire;							
					# }
				# }				
			# }
			
			
			elsif ( (@insStatus == grep { $_ eq "NP1" } @insStatus) and ($numOfInputs==scalar @insStatus) ) {
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 1;
			}					
		}
		
		elsif ($currentGateType eq "NOR") {
			
			if (grep { $_ eq "P1" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P1's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "P1") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 0;					
				}
			}


			if (grep { $_ eq "NP1" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P1's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "NP1") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 0;					
				}
			}
		
			elsif ( (@insStatus == grep { $_ eq "P0" } @insStatus)  ) {		
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 1;
			}
			
			# elsif (grep { $_ eq "NP1" } @insStatus) {
				
				# push @sensQ, $currentGate; 	
				# $movingImp{$currentGate} = 0;				
				
				# foreach $kk (0..scalar @insStatus) {
					
					# $wire = $inStatusGates[$kk];
					# $wireStatus = $insStatus[$kk];
					
					# if ($wireStatus eq "NP1") {						
						# push @processQ, $wire;						
					# }
				# }				
			# }
			
			elsif ( (@insStatus == grep { $_ eq "NP0" } @insStatus) and ($numOfInputs==scalar @insStatus) ) {	
				
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 1;
			}
						
		}
		
		elsif ($currentGateType eq "OR") {
			
			if (grep { $_ eq "P1" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
								
				# COUNT NUMBER OF P1's
				foreach $kk (0..scalar @insStatus - 1) {					
					if ($insStatus[$kk] eq "P1") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {					
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 1;					
				}
			}


			if (grep { $_ eq "NP1" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
								
				# COUNT NUMBER OF P1's
				foreach $kk (0..scalar @insStatus - 1) {					
					if ($insStatus[$kk] eq "NP1") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {					
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 1;					
				}
			}			
		
			elsif ( (@insStatus == grep { $_ eq "P0" } @insStatus)  ) {	
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 0;
			}
			
			# elsif (grep { $_ eq "NP1" } @insStatus) {
			
				# push @sensQ, $currentGate; 
				# $movingImp{$currentGate} = 1;	
												
				# foreach $kk (0..scalar @insStatus) {
					
					# $wire = $inStatusGates[$kk];
					# $wireStatus = $insStatus[$kk];
					
					# if ($wireStatus eq "NP1") {
						# push @processQ, $wire;							
					# }
				# }				
			# }
			
			elsif ( (@insStatus == grep { $_ eq "NP0" } @insStatus) and ($numOfInputs==scalar @insStatus) ) {
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 0;
			}
		
		}
		
		# @sensQ = uniq(@sensQ);
		# @processQ = uniq(@processQ);		
		
		# print "processQ: @processQ, sensQ: @sensQ\n\n";
		# print Dumper \%movingImp;
		###############################################################	
		
	}
	
	####################################################################
	@sensQ = reverse uniq(@sensQ);
	# print "FINAL sensQ: @sensQ\n\n"; 
	# print Dumper \%outPropStatus;
	# print "PATH-TYPE: ",$implicationType{"$newSource:$newTarget"},"\n";
	# exit;
	#----------------------------------------------------------------------
	# BACKWARD TRAVERSAL FINISHED AND FINAL LIST OF PATH GATES IS CREATED
	#----------------------------------------------------------------------
		

	################################################################
	# DECIDE WHETHER THE DIRECT PATH OR INDIRECT PATH FORMULA SHOULD
	# BE APPLIED
	################################################################
	$iFlag = 0;
	my $match1 = grep {$_ eq $newSource} @sensQ;
	my $match2 = grep {$_ eq $source} @sensQ;
	
	if ($match1==0 and $match2==0) {
		
		$implicationType{"$newSource:$newTarget"} = "I";
		$implicationType{"$newSource:$target"} = "I";
		$implicationType{"$source:$target"} = "I";
		$implicationType{"$source:$newTarget"} = "I";
		
		$iFlag = 1;
	}

	else {
		
		foreach $gate (@sensQ) {
			
			if ($gate eq $newTarget) {
				next;
			}
			
			if ($outPropStatus{$gate} =~ m/NP/ or $fanoutCounter{$gate} > 1 ) {
				
				$implicationType{"$newSource:$newTarget"} = "I";
				$implicationType{"$newSource:$target"} = "I";
				$implicationType{"$source:$target"} = "I";
				$implicationType{"$source:$newTarget"} = "I";
				
				$iFlag = 1;
				last;				
			}
		}
	}
	
	if ($iFlag==0) {
		$implicationType{"$newSource:$newTarget"} = "D";
		$implicationType{"$newSource:$target"} = "D";
		$implicationType{"$source:$target"} = "D";
		$implicationType{"$source:$newTarget"} = "D";
	}
	
	# print "IMP-TYPE $source: $newSource:$newTarget: ",$implicationType{"$newSource:$newTarget"},"\n";
	################################################################
		
	$flag = 0;
	###################################################################
	# UPDATE THE STUCK-AT PROBS OF GATES IN THE SENSQ
	###################################################################
	$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$newSource} = $sourceImp;
	$implicationPathGatesMovingImp{$newSource.":".$target}{$newTarget} = $movingImp{$newTarget};
	
	$implicationType{"$newSource:$newTarget"} = "I";
	$implicationType{"$newSource:$target"} = "I";
				
	if ($implicationType{"$newSource:$newTarget"} eq "D") {
				
		foreach $gate (@sensQ) {			
			
			if ($gate eq $newTarget) {
				$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$gate} = $movingImp{$gate};
				last;
			}
			elsif ($gate eq $newSource or (grep {$_ eq $gate} @primaryInputs) ) {
				next;
			}
			
			@t = split("-", $inputs_TEMP{$gate});
			$gateType = shift @t;
			
			if($flag==1) {
				print "CG: $gate ($gatesOPP{$newSource}{$sourceImp}), TYPE: $gateType, IMP: $movingImp{$gate}, Path-Type: ",$implicationType{"$newSource:$newTarget"},", FO: $foTemp{$gate}, R-$newTarget: ",$reachability{$gate.":".$newTarget},"\n";
			}
			
			$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$gate} = $movingImp{$gate};
			$ratio = ($reachability{$gate.":".$newTarget}/$foTemp{$gate});	
						
			if ($movingImp{$gate}==0) {
				
				$PD_OLD = $circuitFaults_TEMP_1{$gate};
				$PE_OLD = $gatesOPP{$gate}{"0"};
				
				if ($PE_OLD ==0) {
					$PO_NEW = 0;								
				}
				else {
					$PO_NEW = $PD_OLD/$PE_OLD * (1 - $gatesOPP{$newSource}{$sourceImp});
				}
				
				$PE_NEW = getExcitationProbability($gate, $newSource, $gateType, $movingImp{$gate});
				$exc{$gate} = $PE_NEW;				
			
				$PD_NEW = $PE_NEW * $PO_NEW ; 					
				
				$circuitFaults_TEMP_1{$gate} = $PD_NEW;				
								
				if ($flag==1) {
					print "Pd-OLD: $PD_OLD, PE_OLD: $PE_OLD, PE-NEW: $PE_NEW, PO_NEW: $PO_NEW,\nPD_SA0: $circuitFaults_TEMP_0{$gate}, PD-NEW_SA1: $PD_NEW, FO: $foTemp{$gate}, R-$newTarget: ",$reachability{$gate.":".$newTarget},", Ratio: $ratio, Path-Type: ",$implicationType{"$newSource:$newTarget"},"\n\n"; 
				}
			}
			
			elsif ($movingImp{$gate}==1) {
			
				$PD_OLD = $circuitFaults_TEMP_0{$gate};
				$PE_OLD = $gatesOPP{$gate}{"1"};
				
				if ($PE_OLD ==0) {
					$PO_NEW = 0;								
				}
				else {
					$PO_NEW = $PD_OLD/$PE_OLD * (1 - $gatesOPP{$newSource}{$sourceImp});
				}
				
				$PE_NEW = getExcitationProbability($gate, $newSource, $gateType, $movingImp{$gate});
				$exc{$gate} = $PE_NEW;
								
				# if ($foTemp{$gate} == $reachability{$gate.":".$newTarget}) {
				$PD_NEW = $PE_NEW * $PO_NEW * $ratio; 	 										
				# }
				# else {							
					# $PD_NEW = $PD_OLD * (1 - ($gatesOPP{$newSource}{$sourceImp}* $ratio) );				
				# }				
				
				$circuitFaults_TEMP_0{$gate} = $PD_NEW;	
				
				if ($flag==1) {
					print "Pd-OLD: $PD_OLD, PE_OLD: $PE_OLD, PE-NEW: $PE_NEW, PO_NEW: $PO_NEW,\nPD-NEW_SA0: $PD_NEW, PD_SA1: $circuitFaults_TEMP_1{$gate}, FO: $foTemp{$gate}, R-$newTarget: ",$reachability{$gate.":".$newTarget},", Ratio: $ratio, Path-Type: ",$implicationType{"$newSource:$newTarget"},"\n\n"; 
				}			
			}
			
			$implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{0} = $circuitFaults_TEMP_0{$gate};
			$implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{1} = $circuitFaults_TEMP_1{$gate};
		}		
	}
		
	else { 
		# print "FINAL SENSQ: @sensQ \n";
		# @sensQ  = @sensQ[1..$#sensQ-1];
		# print "FINAL SENSQ: @sensQ \n";
		
		foreach $gate (@sensQ) {						
			
			if ($gate eq $newTarget) {
				$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$gate} = $movingImp{$gate};
				last;
			}
			elsif ($gate eq $newSource or (grep {$_ eq $gate} @primaryInputs) or (grep {$_ eq $gate} @folCommon) ) {
				next;
			}
			
			@t = split("-", $inputs_TEMP{$gate});
			$gateType = shift @t;
			
			if($flag==1) {
				print "CG: $gate ($gatesOPP{$newSource}{$sourceImp}), TYPE: $gateType, IMP: $movingImp{$gate}, FO: $foTemp{$gate}, R: ",$reachability{$gate.":".$newTarget},", Path-Type: ",$implicationType{"$newSource:$newTarget"},"\n";
			}

			$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$gate} = $movingImp{$gate};
			
			# if ($foTemp{$gate}==0) { $foTemp{$gate} = 1; }
			$ratio = ($reachability{$gate.":".$newTarget}/$foTemp{$gate});
			
			if ($movingImp{$gate}==0) {
				
				$PD_OLD = $circuitFaults_TEMP_1{$gate}/$numberOfTestVectors;
				$PD_NEW = $PD_OLD * (1 - $gatesOPP{$newSource}{$sourceImp}) * $ratio;				
				$circuitFaults_TEMP_1{$gate} = $PD_NEW;	
				
				if ($flag==1) {
					print "Pd-OLD: $PD_OLD, PD_SA0: $circuitFaults_TEMP_0{$gate}, PD-NEW_SA1: $PD_NEW, Mov-Imp: $movingImp{$gate}\n\n"; 
				}
			}
			
			elsif ($movingImp{$gate}==1) {
			
				$PD_OLD = $circuitFaults_TEMP_0{$gate}/$numberOfTestVectors;
				$PD_NEW = $PD_OLD * (1 - $gatesOPP{$newSource}{$sourceImp}) * $ratio;				
				$circuitFaults_TEMP_0{$gate} = $PD_NEW;	
				
				if ($flag==1) {
					print "CG: $gate, Pd-OLD: $PD_OLD, PD-NEW_SA0: $PD_NEW, PD_SA1: $circuitFaults_TEMP_1{$gate}, Mov-Imp: $movingImp{$gate}\n\n"; 
				}				
			}			
			$implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{0} = $circuitFaults_TEMP_0{$gate};
			$implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{1} = $circuitFaults_TEMP_1{$gate};
		}
	}
	###################################################################
	
	$newStuckAtSum = 0;
	$pathGain = 0;
	
	foreach $gate (nsort keys %circuitFaults_TEMP_0) {
		
		if ( (grep {$_ eq $gate} @primaryInputs) or $gate =~ m/>/ ) {
			next;
		}
		else {	
			$newStuckAtSum = $newStuckAtSum + $circuitFaults_TEMP_0{$gate} + $circuitFaults_TEMP_1{$gate};
			
			if ($flag==1) {
				print "$gate: sa0 = $circuitFaults_TEMP_0{$gate}, sa1 = $circuitFaults_TEMP_1{$gate}, S = ",$circuitFaults_TEMP_0{$gate}+$circuitFaults_TEMP_1{$gate},"\n";
			}		
		}	
	}
	
	$pathGain = $newStuckAtSum - $currentSAT;
	
	if ($flag==1) {

		print "\nFINAL-GATES: @sensQ\n\n";	
		# print Dumper \%movingImp; 	
		# print Dumper \%foTemp;
		# print Dumper \%reachability;				
		print Dumper \%inputs_TEMP;		
		print "currentSAT: $currentSAT, newSAT: $newStuckAtSum, Gain: $pathGain, IMP-TYPE: ",$implicationType{"$newSource:$newTarget"},"\n";
	}
		
	
	$sQ = join("-", @sensQ);
	$sensQs{$source.":".$target} = $sQ;
	
	# print "SQ = $sQ\n";
	# print "sensQs = ";
	# print Dumper \%sensQs;
	# exit;
		
	return ($newStuckAtSum, $pathGain);
}
#######################################################

sub stuckAtDue2Implication2 {
	my $source 	=	$_[0];
	my $target 	=	$_[1];
	my $implication = $_[2];
	my $flag = 		$_[3];
					
	%circuitFaults_TEMP_0 = ();
	%circuitFaults_TEMP_1 = ();
	
	%circuitFaults_TEMP_0 = %{ clone (\%circuitFaults_0) };	
	%circuitFaults_TEMP_1 = %{ clone (\%circuitFaults_1) };	
	%implications_TEMP = %{ clone (\%implications) };		
	%inputs_TEMP =  %{ clone (\%inputs) };
	%fanouts_TEMP =  %{ clone (\%fanouts) };		
	
	%impSATs = ();
	%exc = ();
	%foTemp = ();	
	%outPropStatus = ();
	%path = ();
		
	my $sourceImp = (split("_", $implication))[0];
	my $targetImp = (split("_", $implication))[1];
	
	my $sourceGateType = (split("-", $inputs_TEMP{$source}))[0];
	my $targetGateType = (split("-", $inputs_TEMP{$target}))[0];	
			
	$area = 0;		
	$newTarget = $target;
	$newSource = $source;
		
	####################################################################
	# COMPUTE AREA OVERHEAD DUE TO IMPLICATION WIRE ADDED
	####################################################################	
	$targetGateChangedFlag = 0;
	$maskingGateChangedFlag = 0;
	$maskingGate = 0;
	$maskingGateType = 0;

	$maskingGateType = (split("-", $inputs_TEMP{$fanouts_TEMP{$target}}))[0];							
	$maskingGate = (split("-", $fanouts_TEMP{$target}))[0];	
	
			
	if ($implication eq "0_0") {			
	
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NAND" or $maskingGateType eq "AND")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs_TEMP{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.
		if ($maskingGateChangedFlag==1) {		
			$area = $origArea + ($nmosDrainArea + $pmosDrainArea);
			
			if ($maskingGateType eq "NOT") {				
				$inputs_TEMP{$maskingGate} = "NAND-$target-$source";							
			}
			elsif ($maskingGateType eq "NAND" or $maskingGateType eq "AND") {				
				$inputs_TEMP{$maskingGate} .= "-$source";			
			}
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NOR" or $maskingGateType eq "OR") {								
			$area = $origArea + (2*$nmosDrainArea + 2*$pmosDrainArea);		
			
			if ($targetGateType eq "NOT") {	
				
				$input2TargetGate = (split("-", $inputs_TEMP{$target}))[1];															
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} = "NOR-$input2TargetGate-$in2NOT";
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;
				}
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";				
					$inputs_TEMP{$target} = "NOR-$input2TargetGate-IMP_TEMP1";
					
					$circuitFaults_TEMP_0{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
						else {					
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
					}
					else {														
						$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$source};
					}
				}
			}
			
			elsif ($targetGateType eq "NOR") {	
			
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} .= "-$in2NOT";
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;
				}
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} .= "-IMP_TEMP1";	

					$circuitFaults_TEMP_0{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
						else {					
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
					}
					else {						
						$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$source};				
					}
				}
			}
		
			elsif ($targetGateType eq "AND") {							
				$inputs_TEMP{$target} .= "-$source";					
			}			
			elsif ($targetGateType eq "NAND") {	
				
				$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
				$inputs_TEMP{$target} .= "-IMP_TEMP1";		
								
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
			elsif ($targetGateType eq "OR") {							
				$inputs_TEMP{$target} .= "-$source";
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}			
		}						
	}	
	
	elsif ($implication eq "0_1") {	
		
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NOR" or $maskingGateType eq "OR")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs_TEMP{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
			
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.
		if ($maskingGateChangedFlag==1) {
			$area = $origArea + (2*$nmosDrainArea + 2*$pmosDrainArea);	
			
			if ($maskingGateType eq "NOT") {
			
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$maskingGate} = "NOR-$target-$in2NOT";	
					$newSource = $in2NOT;	
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {					
						
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";				
					$inputs_TEMP{$maskingGate} = "NOR-$target-IMP_TEMP1";	

					$circuitFaults_TEMP_0{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
						else {					
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
					}
					else {					
						$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$source};
					}
				}
			}
			
			elsif ($maskingGateType eq "NOR" or $maskingGateType eq "OR") {		
			
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$maskingGate} .= "-$in2NOT";	
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$maskingGate} .= "-IMP_TEMP1";	

					$circuitFaults_TEMP_0{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
						else {					
							$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
					}
					else {					
						$circuitFaults_TEMP_1{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$source};				
					}
				}
			}			
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NAND" or $maskingGateType eq "AND") {			
			
			$area = $origArea + ($nmosDrainArea + $pmosDrainArea);
			
			if ($targetGateType eq "NOT") {			
				$input2TargetGate = (split("-", $inputs_TEMP{$target}))[1];															
				$inputs_TEMP{$target} = "NAND-$input2TargetGate-$source";		
			}
		
			elsif ($targetGateType eq "NAND") {			
				$inputs_TEMP{$target} .= "-$source";				
			}
			
			elsif ($targetGateType eq "OR" ) {			
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} .= "-$in2NOT";
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;					
				}				
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} .= "-IMP_TEMP1";		

					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;

					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {						
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};				
					}				
				}
			}
		
			elsif ($targetGateType eq "NOR") {							
				$inputs_TEMP{$target} .= "-$source";
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
			elsif ($targetGateType eq "AND") {	
				
				$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
				$inputs_TEMP{$target} .= "-IMP_TEMP1";		
								
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
		}						
	}
	
	elsif ($implication eq "1_0") {	
		
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NAND" or $maskingGateType eq "AND")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs_TEMP{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.
		if ($maskingGateChangedFlag==1) {
			
			$area = $origArea + (2*$nmosDrainArea + 2*$pmosDrainArea);
			
			if ($maskingGateType eq "NOT") {	
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$maskingGate} = "NAND-$target-$in2NOT";
					$newSource = $in2NOT;	
					$sourceImp = ($sourceImp+1)%2;
				}
				else {			
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";				
					$inputs_TEMP{$maskingGate} = "NAND-$target-IMP_TEMP1";	
					
					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {								
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};
					}
				}
			}
		
			elsif ($maskingGateType eq "NAND" or $maskingGateType eq "AND") {	
			
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$maskingGate} .= "-$in2NOT";		
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {	
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$maskingGate} .= "-IMP_TEMP1";		

					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {						
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};				
					}
				}
			}
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NOR" or $maskingGateType eq "OR") {			
			
			$area = $origArea + ($nmosDrainArea + $pmosDrainArea);
			
			if ($targetGateType eq "NOT") {							
				$input2TargetGate = (split("-", $inputs_TEMP{$target}))[1];				
				$inputs_TEMP{$target} = "NOR-$input2TargetGate-$source";								
			}
			
			elsif ($targetGateType eq "NOR") {			
				$inputs_TEMP{$target} .= "-$source";			
			}
			
			elsif ($targetGateType eq "AND") {	
			
				if ($sourceGateType eq "NOT") {
					
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} .= "-$in2NOT";
					$newSource = $in2NOT;	
					$sourceImp = ($sourceImp+1)%2;
				}				
				else {
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} .= "-IMP_TEMP1";		

					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;

					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {						
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};				
					}				
				}
			}			
			elsif ($targetGateType eq "NAND") {							
				$inputs_TEMP{$target} .= "-$source";
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
			elsif ($targetGateType eq "OR") {	
				
				$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
				$inputs_TEMP{$target} .= "-IMP_TEMP1";		
								
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
		}	
	}
		
	elsif ($implication eq "1_1") {	
		
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NOR" or $maskingGateType eq "OR")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs_TEMP{$newTarget}))[0];
		}
		
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.				
		if ($maskingGateChangedFlag==1) {			
			$area = $origArea + ($nmosDrainArea + $pmosDrainArea);	
			
			if ($maskingGateType eq "NOT") {
				$inputs_TEMP{$maskingGate} = "NOR-$target-$source";		
			}
			elsif ($maskingGateType eq "NOR" or $maskingGateType eq "OR") {
				$inputs_TEMP{$maskingGate} .= "-$source";			
			}
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NAND" or $maskingGateType eq "AND") {	
			$area = $origArea + (2*$nmosDrainArea + 2*$pmosDrainArea);		
						
			if ($targetGateType eq "NOT") {			
			
				$input2TargetGate = (split("-", $inputs_TEMP{$target}))[1];					
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} = "NAND-$input2TargetGate-$in2NOT";	
					$newSource = $in2NOT;	
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {				
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} = "NAND-$input2TargetGate-IMP_TEMP1";	

					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {					
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};
					}
				}
			}		
			
			elsif ($targetGateType eq "NAND") {
				
				if ($sourceGateType eq "NOT") {
					$in2NOT = (split("-", $inputs_TEMP{$source}))[1];
					$inputs_TEMP{$target} .= "-$in2NOT";	
					$newSource = $in2NOT;
					$sourceImp = ($sourceImp+1)%2;					
				}
				else {					
					$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
					$inputs_TEMP{$target} .= "-IMP_TEMP1";
						
					$circuitFaults_TEMP_1{"IMP_TEMP1"} = 0;
				
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$target};
						}
						else {					
							$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_0{$target};
						}
					}
					else {					
						$circuitFaults_TEMP_0{"IMP_TEMP1"} = $circuitFaults_TEMP_1{$source};
					}
				}
			}
			
			elsif ($targetGateType eq "OR") {							
				$inputs_TEMP{$target} .= "-$source";					
			}
						
			elsif ($targetGateType eq "NOR") {	
				
				$inputs_TEMP{"IMP_TEMP1"} = "NOT-$source";
				$inputs_TEMP{$target} .= "-IMP_TEMP1";		
								
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
			elsif ($targetGateType eq "AND") {							
				$inputs_TEMP{$target} .= "-$source";
				# print "$source=$sourceImp==>$target=$targetImp CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
				return ($currentSAT, 0);
			}
		}						
	}			
	####################################################################	
			
	if ($flag==1) {
		print "\n-----------------------------------------------------------------------------------------------------------------------------------\n\n";
		print "==>SOURCE: $source ($sourceGateType, P$sourceImp: $gatesOPP{$source}{$sourceImp}), N-S: $newSource, A-T: $target ($targetGateType), N-T: $newTarget, M-G: $maskingGate($maskingGateType, $maskingGateChangedFlag), IMP: $implication, T-FLAG: $targetGateChangedFlag, Area: $area, FO-S: $fanoutCounter{$newSource}, GL-S: ",$gateLevel{$newSource},", GL-T: ",$gateLevel{$target},"\n"; 
	}
		
	###################################################
	# IF SOURCE IS DIRECTLY FEEDING THE TARGET THEN 
	# NO NEED TO COMPUTE STUCK-AT.
	###################################################
	@ins = split("-", $inputs{$newTarget});
	# print "INS: @ins \n"; exit;
	if (grep {$_ eq $newSource} @ins) {
		return ($currentSAT, 0);
	}	
	if ($newSource eq $newTarget) {		
		return ($currentSAT, 0);
	}
	###################################################
	

	$implicationType{"$newSource:$newTarget"} = 0;			
		
	if( $newTarget eq $target ) {		
		$reachability{$source.":".$target} = 0;		
		$reachability{$newSource.":".$target} = 0;		
	}
	else {
		$reachability{$source.":".$target} = 0;		
		$reachability{$source.":".$newTarget} = 0;	
		$reachability{$source.":".$target} = 0;		
		$reachability{$newSource.":".$newTarget} = 0;			
	}
	
	###########################################################################
	# COMPUTE REACHABLE PATHS FROM SOURCE GATE TO THE TARGET
	###########################################################################
	# pathFinder($newSource, $newTarget, 0);
						
	$foTemp{$newSource} = 1;
	foreach $key (sort keys %{ $path{$newSource} }) {													
		$foTemp{$newSource} += 1;													
	}
	###########################################################################
		
	#------------------------------------------------------------------------------
	#Check the paths for the existence of TARGET gate in DIRECT PATH.	
	#------------------------------------------------------------------------------
	@processQ = ();
		
	$counter = 0;
	$movingImp = $sourceImp;
	$currentPathImp = $sourceImp;
	
	@outs = split("-", $fanouts{$newSource});
	foreach $out (@outs) {
		push @processQ, $out
	}
	
	if ($sourceImp==0) {
		$outPropStatus{$newSource} = "P0";
	}
	
	elsif ($sourceImp==1) {
		$outPropStatus{$newSource} = "P1";
	}	
		
	while (scalar @processQ != 0) {
	
		$currentGate = shift @processQ;
		
		@ins = split("-", $inputs{$currentGate});	
		$gateType = shift @ins;
		$numOfInputs = scalar @ins;
		
		if ($flag==1) {
			print "\nCG: $currentGate, Type: $gateType, CPI: $currentPathImp, INS: @ins, # of ins: $numOfInputs\n"; 						
		}
		
		# Process Each input of the current gate
		@inWiresStatus = ();
		foreach $in (@ins) {
			if (exists($outPropStatus{$in})) {
				push @inWiresStatus, $outPropStatus{$in};
			}			
		}
		
		# print "@inWiresStatus \n"; 
		# print Dumper \%outPropStatus;
		
		############################################################################
		# UPDATE PATH GATES THAT DRIVE THE IMPLICATION
		############################################################################
		if ($gateType eq "NOT") {
			
			if (grep {$_ eq "P0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P1";
			}
			elsif (grep {$_ eq "P1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P0";
			}			
			elsif (grep {$_ eq "NP0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}			
			elsif (grep {$_ eq "NP1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP0";
			}			
			
			$currentPathImp = ($currentPathImp+1)%2;							
		}
		
		elsif ($gateType eq "NAND") {
			
			if (grep {$_ eq "P0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P1";
			}			
			elsif ( (@inWiresStatus == grep { $_ eq "P1" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
				$outPropStatus{$currentGate} = "P0";
			}
			elsif (grep {$_ eq "NP0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}					
			elsif (@inWiresStatus == grep { $_ eq "NP1" } @inWiresStatus)  {
				$outPropStatus{$currentGate} = "NP0";
			}
			else {
				$outPropStatus{$currentGate} = "NP0";
			}			
			
			$currentPathImp = ($currentPathImp+1)%2;							
		}
		
		elsif ($gateType eq "AND") {
		
			if (grep {$_ eq "P0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P0";
			}			
			elsif ( (@inWiresStatus == grep { $_ eq "P1" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
				$outPropStatus{$currentGate} = "P1";
			}
			elsif (grep {$_ eq "NP0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP0";
			}			
			elsif (@inWiresStatus == grep { $_ eq "NP1" } @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}				
			else {
				$outPropStatus{$currentGate} = "NP1";
			}						
		}
		
		elsif ($gateType eq "NOR") {				
		
			if (grep {$_ eq "P1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P0";
			}			
			elsif ( (@inWiresStatus == grep { $_ eq "P0" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
				$outPropStatus{$currentGate} = "P1";
			}
			elsif (grep {$_ eq "NP1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP0";
			}			
			elsif (@inWiresStatus == grep { $_ eq "NP0" } @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}	
			elsif (grep {$_ eq "P0"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}
			else {
				$outPropStatus{$currentGate} = "NP1";
			}						
						
			$currentPathImp = ($currentPathImp+1)%2;
		}								
				
		elsif ($gateType eq "OR") {							
									
			if (grep {$_ eq "P1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "P1";
			}			
			elsif ( (@inWiresStatus == grep { $_ eq "P0" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
				$outPropStatus{$currentGate} = "P0";
			}
			elsif (grep {$_ eq "NP1"} @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP1";
			}			
			elsif (@inWiresStatus == grep { $_ eq "NP0" } @inWiresStatus) {
				$outPropStatus{$currentGate} = "NP0";
			}			
			else {
				$outPropStatus{$currentGate} = "NP0";
			}						
		}
		
								
		@outs = split("-", $fanouts{$currentGate});
		foreach $out (@outs) {
			if (!(grep{$_ eq $out} @processQ) and !(grep({$_ eq $out} @primaryOutputs)) ) {
				push @processQ, $out;
			}
		}
		
		
		###########################################################################
		# COMPUTE REACHABLE PATHS FROM CURRENT GATE TO THE TARGET
		###########################################################################
		$reachability{$currentGate.":".$newTarget} = 0;
		#pathFinder($currentGate, $newTarget, 0);			
						
		$foTemp{$currentGate} = 1;
		foreach $key (sort keys %{ $path{$currentGate} }) {													
			$foTemp{$currentGate} += 1;
			if (exists($path{$currentGate}{$key})) {	
			
				# $implicationType{"$newSource:$newTarget"} = "D";
				# $implicationType{"$newSource:$target"} = "D";
			
				if ($path{$currentGate}{$key} =~ /\b$newTarget\b/) {
					$reachability{$currentGate.":".$newTarget} += 1;								
				}
			}
		}					
		###########################################################################
		
		if ($flag==1) {
			print "\nCG: $currentGate, Type: $gateType, Area = $area, FO: $foTemp{$currentGate}, R-$newTarget: ",$reachability{$currentGate.":".$newTarget},", Path-Type: ",$implicationType{"$newSource:$newTarget"},"\n"; 								
			# print "ProcessQ: @processQ\n";
		}		
	}				
			

	# print Dumper \%outPropStatus; 
	
	#------------------------------------------------------------------------------
	# DIRECT PATH DISCOVERY FINISHED HERE
	#------------------------------------------------------------------------------
	
	# if ($implicationType{"$newSource:$newTarget"} ne "D") {
		# $implicationType{"$newSource:$newTarget"} = "I";
		# $implicationType{"$newSource:$target"} = "I";
	# }
	# print Dumper \%outPropStatus;
	#------------------------------------------------------------------------------
	#If there is no forward path between the SOURCE and the TARGET, then we have to 
	#iterate backwards to find the common lowest level stem that has both SOURCE and 
	#TARGET gate in its path. PHEW... :(
	#------------------------------------------------------------------------------
	# $flag = 1;
	# print "S: $source, T: $target, SOURCE FOL: $FOL{$source}, TARGET FOL: $FOL{$target}, IMP: $implication, I-PATH: $indirectPath\n";		
		
	my @folCommon = split(/[-;]/, intersection($FOL{$newSource}, $FOL{$newTarget}));
			
	@comm = ();
	@pathGates = ();
	
	foreach $k (@folCommon) {
		if ($k =~ m/\D/ and $k ne $newSource) {
			push @comm, $k;
		}				
	}
	@folCommon = @{ dclone(\@comm) };	
	@folCommon =  nsort @folCommon;
				
	if ($flag==1) {
		print "\n--COMMON: @folCommon\n";   
		# $cin=getc(STDIN);	
	}
	
	if (scalar @folCommon==1 and $folCommon[0] eq "0_0") {
		@folCommon = ();
	}
	
	foreach $src (@folCommon) {
		
		if ($src =~ m/\D/) {						
			#pathFinder($src, $newTarget, 0);					
			my $targetFound = 0;	
			my $sourceFound = 0;										

			#Compute the implication polarity at current source by iterating
			#from current common SRC to the actual implication source and counting
			#the number of inverters.
			$newSourceImp = $sourceImp;
			foreach $key (sort keys %{ $path{$src} }) {								
				if (exists($path{$src}{$key})) {
					if ($path{$src}{$key} =~ /\b$newSource\b/ and $sourceFound==0) {
						my @temp = ();
						
						if ($path{$src}{$key} =~ m/-/) {
							@temp = split ("-", $path{$src}{$key});
						}
						else {
							push @temp, $path{$src}{$key};
						}
																																		
						$counter = 0;							
						while ($temp[$counter] ne $newSource) {
						
							$counter++;
							@t = split("-", $inputs_TEMP{$temp[$counter]});
							$gateType = shift @t;									
						
							if ($gateType eq "NOT" or $gateType eq "NAND" or $gateType eq "NOR") {								
								$newSourceImp = ($newSourceImp+1)%2;
							}							
						}
						$sourceFound++;	
					}
				}
			}				
			
			if ($flag==1) {
				print "\n--STARTING NODE: $src, NEW SOURCE-IMP: $newSourceImp\n"; 			
				# print Dumper $path{$src};				
				# $cin=getc(STDIN);	exit;
			}					
			
			#Check the paths for the existence of TARGET gate.							
			@processQ = ();
												
			$movingImp = $newSourceImp;				
			$currentPathImp = $newSourceImp;

			@outs = split("-", $fanouts{$src});
			foreach $out (@outs) {
				if ($out ne $newSource) {
					push @processQ, $out;
				}
			}
			
			if ($newSourceImp==0) {
				$outPropStatus{$src} = "P0";
			}
			elsif ($newSourceImp==1) {
				$outPropStatus{$src} = "P1";
			}
			
			while (scalar @processQ != 0) {
	
				$currentGate = shift @processQ;
				
				@ins = split("-", $inputs{$currentGate});	
				$gateType = shift @ins;
				$numOfInputs = scalar @ins;
				
				if ($flag==1) {
					print "\nCG: $currentGate, Type: $gateType, CPI: $currentPathImp, INS: @ins, # of ins: $numOfInputs\n"; 						
				}
				
				# Process Each input of the current gate
				@inWiresStatus = ();
				foreach $in (@ins) {
					if (exists($outPropStatus{$in})) {
						push @inWiresStatus, $outPropStatus{$in};
					}			
				}
				
				# print "IN: @inWiresStatus \n"; 
				# print Dumper \%outPropStatus;
				
				############################################################################
				# UPDATE PATH GATES THAT DRIVE THE IMPLICATION
				############################################################################
				if ($gateType eq "NOT") {
					
					if (grep {$_ eq "P0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P1";
					}
					elsif (grep {$_ eq "P1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P0";
					}			
					elsif (grep {$_ eq "NP0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}			
					elsif (grep {$_ eq "NP1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP0";
					}			
					
					$currentPathImp = ($currentPathImp+1)%2;							
				}
				
				elsif ($gateType eq "NAND") {
					
					if (grep {$_ eq "P0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P1";
					}			
					elsif ( (@inWiresStatus == grep { $_ eq "P1" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
						$outPropStatus{$currentGate} = "P0";
					}
					elsif (grep {$_ eq "NP0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}					
					elsif (@inWiresStatus == grep { $_ eq "NP1" } @inWiresStatus)  {
						$outPropStatus{$currentGate} = "NP0";
					}
					else {
						$outPropStatus{$currentGate} = "NP0";
					}			
					
					$currentPathImp = ($currentPathImp+1)%2;							
				}
				
				elsif ($gateType eq "AND") {
				
					if (grep {$_ eq "P0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P0";
					}			
					elsif ( (@inWiresStatus == grep { $_ eq "P1" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
						$outPropStatus{$currentGate} = "P1";
					}
					elsif (grep {$_ eq "NP0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP0";
					}			
					elsif (@inWiresStatus == grep { $_ eq "NP1" } @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}				
					else {
						$outPropStatus{$currentGate} = "NP1";
					}						
				}
				
				elsif ($gateType eq "NOR") {				
				
					if (grep {$_ eq "P1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P0";
					}			
					elsif ( (@inWiresStatus == grep { $_ eq "P0" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
						$outPropStatus{$currentGate} = "P1";
					}
					elsif (grep {$_ eq "NP1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP0";
					}			
					elsif (@inWiresStatus == grep { $_ eq "NP0" } @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}	
					elsif (grep {$_ eq "P0"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}
					else {
						$outPropStatus{$currentGate} = "NP1";
					}						
								
					$currentPathImp = ($currentPathImp+1)%2;
				}								
						
				elsif ($gateType eq "OR") {							
											
					if (grep {$_ eq "P1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "P1";
					}			
					elsif ( (@inWiresStatus == grep { $_ eq "P0" } @inWiresStatus) and ($numOfInputs== scalar @inWiresStatus) ) {
						$outPropStatus{$currentGate} = "P0";
					}
					elsif (grep {$_ eq "NP1"} @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP1";
					}			
					elsif (@inWiresStatus == grep { $_ eq "NP0" } @inWiresStatus) {
						$outPropStatus{$currentGate} = "NP0";
					}			
					else {
						$outPropStatus{$currentGate} = "NP0";
					}						
				}
				
							
				@outs = split("-", $fanouts{$currentGate});
				foreach $out (@outs) {
					if ( !(grep{$_ eq $out} @processQ) ) {
						push @processQ, $out;
					}
				}				
				############################################################################
				
				###########################################################################
				# COMPUTE REACHABLE PATHS FROM CURRENT GATE TO THE TARGET
				###########################################################################
				$reachability{$currentGate.":".$newTarget} = 0;
				#pathFinder($currentGate, $newTarget, 0);					
								
				$foTemp{$currentGate} = 1;
				foreach $key (sort keys %{ $path{$currentGate} }) {													
					$foTemp{$currentGate} += 1;
					if (exists($path{$currentGate}{$key})) {		
						if ($path{$currentGate}{$key} =~ /\b$newTarget\b/) {
							$reachability{$currentGate.":".$newTarget} += 1;								
						}
					}
				}											
				###########################################################################	
				
				if ($flag==1) {
					print "\nCG: $currentGate, Type: $gateType, Area = $area, FO: $foTemp{$currentGate}, R-$newTarget: ",$reachability{$currentGate.":".$newTarget},", Path-Type: D\n"; 								
					print "ProcessQ: @processQ\n";
				}			
			}	
		}
	}		

	#------------------------------------------------------------------------------
	# INDIRECT PATH DISCOVERY FINISHED HERE
	#------------------------------------------------------------------------------
					
	#-------------------------------------------------------------------
	# TRAVERSE BACKWARDS TO CONSTRUCT THE FINAL PATH GATES
	#-------------------------------------------------------------------
	my @processQ = ();
	my @sensQ = ();		
	my %movingImp = ();
	
		
	push @processQ, $newTarget; 	
	
	# print "processQ: @processQ \n";
	
	while (scalar @processQ != 0) {
		
		$currentGate = shift @processQ;
		
		if ($currentGate eq $newSource) {
			$movingImp{$currentGate} = ($outPropStatus{$currentGate} =~ m/\d/)[0];
			push @sensQ, $currentGate;					
			next;
		}
		
		# PROCESS INPUTS OF CURRENT GATE
		@ins = split("-", $inputs{$currentGate});
		$currentGateType = shift @ins;
		$numOfInputs = scalar @ins;
		
		# print "CG: $currentGate, $currentGateType, INS: @ins, # of ins: $numOfInputs\n";
		@insStatus = ();
		@inStatusGates = ();		
				
		foreach $in (@ins) {
			if (exists($outPropStatus{$in})) {				
				push @insStatus, $outPropStatus{$in};
				push @inStatusGates, $in;
			}			
		}			
		
		# print "insStatus: @insStatus, @inStatusGates\n"; 		
		
		if (scalar @inStatusGates == 0) {
			$movingImp{$currentGate} = ($outPropStatus{$currentGate} =~ m/\d/)[0];
			push @sensQ, $currentGate;
			next;			
		}
		
		###############################################################
		# RULES ARE ADDED HERE TO CONSTRUCT THE FINAL PATH GATES
		###############################################################
		if ($currentGateType eq "NOT") {
			
			push @sensQ, $currentGate;			
			push @processQ, @inStatusGates;

			$inStat = shift @insStatus;
			
			if ($inStat eq "P0" or $inStat eq "NP0") {
				$movingImp{$currentGate} = 1;
			}
			elsif ($inStat eq "P1" or $inStat eq "NP1") {
				$movingImp{$currentGate} = 0;
			}
		}
	
		elsif ($currentGateType eq "NAND") {
									
			if (grep { $_ eq "P0" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P0's or NP0's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "P0") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 1;				
				}
			}
			
			if (grep { $_ eq "NP0" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P0's or NP0's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "NP0") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 1;				
				}
			}

			elsif ( (@insStatus == grep { $_ eq "P1" } @insStatus)  ) {	
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 0;
			}			
			
			# elsif (grep { $_ eq "NP0" } @insStatus) {
				
				# push @sensQ, $currentGate; 
				# $movingImp{$currentGate} = 1;					
								
				# foreach $kk (0..scalar @insStatus) {
					
					# $wire = $inStatusGates[$kk];
					# $wireStatus = $insStatus[$kk];
					
					# if ($wireStatus eq "NP0") {						
						# push @processQ, $wire;							
					# }
				# }				
			# }			
		
			elsif ( (@insStatus == grep { $_ eq "NP1" } @insStatus) and ($numOfInputs==scalar @insStatus) ) {
				
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 0;
			}
						
		}
		
		elsif ($currentGateType eq "AND") {
			
			if (grep { $_ eq "P0" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P0's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "P0") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 0;					
				}
			}			
					
			
			if (grep { $_ eq "NP0" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P0's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "NP0") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 0;					
				}
			}			
			
			
			elsif ( (@insStatus == grep { $_ eq "P1" } @insStatus)  ) {	
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 1;
			}
			
			
			# elsif (grep { $_ eq "NP0" } @insStatus) {
			
				# push @sensQ, $currentGate; 				
				# $movingImp{$currentGate} = 0;
												
				# foreach $kk (0..scalar @insStatus) {
					
					# $wire = $inStatusGates[$kk];
					# $wireStatus = $insStatus[$kk];
					
					# if ($wireStatus eq "NP0") {						
						# push @processQ, $wire;							
					# }
				# }				
			# }
			
			
			elsif ( (@insStatus == grep { $_ eq "NP1" } @insStatus) and ($numOfInputs==scalar @insStatus) ) {
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 1;
			}					
		}
		
		elsif ($currentGateType eq "NOR") {
			
			if (grep { $_ eq "P1" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P1's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "P1") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 0;					
				}
			}


			if (grep { $_ eq "NP1" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
				# COUNT NUMBER OF P1's
				foreach $kk (0..scalar @insStatus - 1) {
					if ($insStatus[$kk] eq "NP1") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 0;					
				}
			}
		
			elsif ( (@insStatus == grep { $_ eq "P0" } @insStatus)  ) {		
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 1;
			}
			
			# elsif (grep { $_ eq "NP1" } @insStatus) {
				
				# push @sensQ, $currentGate; 	
				# $movingImp{$currentGate} = 0;				
				
				# foreach $kk (0..scalar @insStatus) {
					
					# $wire = $inStatusGates[$kk];
					# $wireStatus = $insStatus[$kk];
					
					# if ($wireStatus eq "NP1") {						
						# push @processQ, $wire;						
					# }
				# }				
			# }
			
			elsif ( (@insStatus == grep { $_ eq "NP0" } @insStatus) and ($numOfInputs==scalar @insStatus) ) {	
				
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 1;
			}
						
		}
		
		elsif ($currentGateType eq "OR") {
			
			if (grep { $_ eq "P1" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
								
				# COUNT NUMBER OF P1's
				foreach $kk (0..scalar @insStatus - 1) {					
					if ($insStatus[$kk] eq "P1") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {					
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 1;					
				}
			}


			if (grep { $_ eq "NP1" } @insStatus) {
			
				$pCount = 0;				
				$pGate = 0;
								
				# COUNT NUMBER OF P1's
				foreach $kk (0..scalar @insStatus - 1) {					
					if ($insStatus[$kk] eq "NP1") {
						$pCount++;
						$pGate = $inStatusGates[$kk];
					}				
				}
				
				if ($pCount > 1) {
					# print "No need to protect .. \n";
				}
				else {					
					
					push @sensQ, $currentGate; 					
					push @processQ, $pGate;
					$movingImp{$currentGate} = 1;					
				}
			}			
		
			elsif ( (@insStatus == grep { $_ eq "P0" } @insStatus)  ) {	
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 0;
			}
			
			# elsif (grep { $_ eq "NP1" } @insStatus) {
			
				# push @sensQ, $currentGate; 
				# $movingImp{$currentGate} = 1;	
												
				# foreach $kk (0..scalar @insStatus) {
					
					# $wire = $inStatusGates[$kk];
					# $wireStatus = $insStatus[$kk];
					
					# if ($wireStatus eq "NP1") {
						# push @processQ, $wire;							
					# }
				# }				
			# }
			
			elsif ( (@insStatus == grep { $_ eq "NP0" } @insStatus) and ($numOfInputs==scalar @insStatus) ) {
			
				push @sensQ, $currentGate; 				
				push(@processQ, @inStatusGates);
				$movingImp{$currentGate} = 0;
			}
		
		}
		
		# @sensQ = uniq(@sensQ);
		# @processQ = uniq(@processQ);		
		
		# print "processQ: @processQ, sensQ: @sensQ\n\n";
		# print Dumper \%movingImp;
		###############################################################	
		
	}
	
	####################################################################
	@sensQ = reverse uniq(@sensQ);
	# print "FINAL sensQ: @sensQ\n\n"; 
	# print Dumper \%outPropStatus;
	# print "PATH-TYPE: ",$implicationType{"$newSource:$newTarget"},"\n";
	# exit;
	#----------------------------------------------------------------------
	# BACKWARD TRAVERSAL FINISHED AND FINAL LIST OF PATH GATES IS CREATED
	#----------------------------------------------------------------------
		

	################################################################
	# DECIDE WHETHER THE DIRECT PATH OR INDIRECT PATH FORMULA SHOULD
	# BE APPLIED
	################################################################
	$iFlag = 0;
	my $match1 = grep {$_ eq $newSource} @sensQ;
	my $match2 = grep {$_ eq $source} @sensQ;
	
	if ($match1==0 and $match2==0) {
		
		$implicationType{"$newSource:$newTarget"} = "I";
		$implicationType{"$newSource:$target"} = "I";
		$implicationType{"$source:$target"} = "I";
		$implicationType{"$source:$newTarget"} = "I";
		
		$iFlag = 1;
	}

	else {
		
		foreach $gate (@sensQ) {
			
			if ($gate eq $newTarget) {
				next;
			}
			
			if ($outPropStatus{$gate} =~ m/NP/ or $fanoutCounter{$gate} > 1 ) {
				
				$implicationType{"$newSource:$newTarget"} = "I";
				$implicationType{"$newSource:$target"} = "I";
				$implicationType{"$source:$target"} = "I";
				$implicationType{"$source:$newTarget"} = "I";
				
				$iFlag = 1;
				last;				
			}
		}
	}
	
	if ($iFlag==0) {
		$implicationType{"$newSource:$newTarget"} = "D";
		$implicationType{"$newSource:$target"} = "D";
		$implicationType{"$source:$target"} = "D";
		$implicationType{"$source:$newTarget"} = "D";
	}
	
	# print "IMP-TYPE $source: $newSource:$newTarget: ",$implicationType{"$newSource:$newTarget"},"\n";
	################################################################
		
	$flag = 0;
	###################################################################
	# UPDATE THE STUCK-AT PROBS OF GATES IN THE SENSQ
	###################################################################
	$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$newSource} = $sourceImp;
	$implicationPathGatesMovingImp{$newSource.":".$target}{$newTarget} = $movingImp{$newTarget};
	
	$implicationType{"$newSource:$newTarget"} = "I";
	$implicationType{"$newSource:$target"} = "I";
				
	if ($implicationType{"$newSource:$newTarget"} eq "D") {
				
		foreach $gate (@sensQ) {			
			
			if ($gate eq $newTarget) {
				$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$gate} = $movingImp{$gate};
				last;
			}
			elsif ($gate eq $newSource or (grep {$_ eq $gate} @primaryInputs) ) {
				next;
			}
			
			@t = split("-", $inputs_TEMP{$gate});
			$gateType = shift @t;
			
			if($flag==1) {
				print "CG: $gate ($gatesOPP{$newSource}{$sourceImp}), TYPE: $gateType, IMP: $movingImp{$gate}, Path-Type: ",$implicationType{"$newSource:$newTarget"},", FO: $foTemp{$gate}, R-$newTarget: ",$reachability{$gate.":".$newTarget},"\n";
			}
			
			$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$gate} = $movingImp{$gate};
			$ratio = ($reachability{$gate.":".$newTarget}/$foTemp{$gate});	
						
			if ($movingImp{$gate}==0) {
				
				$PD_OLD = $circuitFaults_TEMP_1{$gate};
				$PE_OLD = $gatesOPP{$gate}{"0"};
				
				if ($PE_OLD ==0) {
					$PO_NEW = 0;								
				}
				else {
					$PO_NEW = $PD_OLD/$PE_OLD * (1 - $gatesOPP{$newSource}{$sourceImp});
				}
				
				$PE_NEW = getExcitationProbability($gate, $newSource, $gateType, $movingImp{$gate});
				$exc{$gate} = $PE_NEW;				
			
				$PD_NEW = $PE_NEW * $PO_NEW ; 					
				
				$circuitFaults_TEMP_1{$gate} = $PD_NEW;				
								
				if ($flag==1) {
					print "Pd-OLD: $PD_OLD, PE_OLD: $PE_OLD, PE-NEW: $PE_NEW, PO_NEW: $PO_NEW,\nPD_SA0: $circuitFaults_TEMP_0{$gate}, PD-NEW_SA1: $PD_NEW, FO: $foTemp{$gate}, R-$newTarget: ",$reachability{$gate.":".$newTarget},", Ratio: $ratio, Path-Type: ",$implicationType{"$newSource:$newTarget"},"\n\n"; 
				}
			}
			
			elsif ($movingImp{$gate}==1) {
			
				$PD_OLD = $circuitFaults_TEMP_0{$gate};
				$PE_OLD = $gatesOPP{$gate}{"1"};
				
				if ($PE_OLD ==0) {
					$PO_NEW = 0;								
				}
				else {
					$PO_NEW = $PD_OLD/$PE_OLD * (1 - $gatesOPP{$newSource}{$sourceImp});
				}
				
				$PE_NEW = getExcitationProbability($gate, $newSource, $gateType, $movingImp{$gate});
				$exc{$gate} = $PE_NEW;
								
				# if ($foTemp{$gate} == $reachability{$gate.":".$newTarget}) {
				$PD_NEW = $PE_NEW * $PO_NEW * $ratio; 	 										
				# }
				# else {							
					# $PD_NEW = $PD_OLD * (1 - ($gatesOPP{$newSource}{$sourceImp}* $ratio) );				
				# }				
				
				$circuitFaults_TEMP_0{$gate} = $PD_NEW;	
				
				if ($flag==1) {
					print "Pd-OLD: $PD_OLD, PE_OLD: $PE_OLD, PE-NEW: $PE_NEW, PO_NEW: $PO_NEW,\nPD-NEW_SA0: $PD_NEW, PD_SA1: $circuitFaults_TEMP_1{$gate}, FO: $foTemp{$gate}, R-$newTarget: ",$reachability{$gate.":".$newTarget},", Ratio: $ratio, Path-Type: ",$implicationType{"$newSource:$newTarget"},"\n\n"; 
				}			
			}
			
			$implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{0} = $circuitFaults_TEMP_0{$gate};
			$implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{1} = $circuitFaults_TEMP_1{$gate};
		}		
	}
		
	else { 
		# print "FINAL SENSQ: @sensQ \n";
		# @sensQ  = @sensQ[1..$#sensQ-1];
		# print "FINAL SENSQ: @sensQ \n";
		
		foreach $gate (@sensQ) {						
			
			if ($gate eq $newTarget) {
				$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$gate} = $movingImp{$gate};
				last;
			}
			elsif ($gate eq $newSource or (grep {$_ eq $gate} @primaryInputs) or (grep {$_ eq $gate} @folCommon) ) {
				next;
			}
			
			@t = split("-", $inputs_TEMP{$gate});
			$gateType = shift @t;
			
			if($flag==1) {
				print "CG: $gate ($gatesOPP{$newSource}{$sourceImp}), TYPE: $gateType, IMP: $movingImp{$gate}, FO: $foTemp{$gate}, R: ",$reachability{$gate.":".$newTarget},", Path-Type: ",$implicationType{"$newSource:$newTarget"},"\n";
			}

			$implicationPathGatesMovingImp{$newSource.":".$newTarget}{$gate} = $movingImp{$gate};
			
			# if ($foTemp{$gate}==0) { $foTemp{$gate} = 1; }
			$ratio = ($reachability{$gate.":".$newTarget}/$foTemp{$gate});
			
			if ($movingImp{$gate}==0) {
				
				$PD_OLD = $circuitFaults_TEMP_1{$gate}/$numberOfTestVectors;
				$PD_NEW = $PD_OLD * (1 - $gatesOPP{$newSource}{$sourceImp}) * $ratio;				
				$circuitFaults_TEMP_1{$gate} = $PD_NEW;	
				
				if ($flag==1) {
					print "Pd-OLD: $PD_OLD, PD_SA0: $circuitFaults_TEMP_0{$gate}, PD-NEW_SA1: $PD_NEW, Mov-Imp: $movingImp{$gate}\n\n"; 
				}
			}
			
			elsif ($movingImp{$gate}==1) {
			
				$PD_OLD = $circuitFaults_TEMP_0{$gate}/$numberOfTestVectors;
				$PD_NEW = $PD_OLD * (1 - $gatesOPP{$newSource}{$sourceImp}) * $ratio;				
				$circuitFaults_TEMP_0{$gate} = $PD_NEW;	
				
				if ($flag==1) {
					print "CG: $gate, Pd-OLD: $PD_OLD, PD-NEW_SA0: $PD_NEW, PD_SA1: $circuitFaults_TEMP_1{$gate}, Mov-Imp: $movingImp{$gate}\n\n"; 
				}				
			}			
			$implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{0} = $circuitFaults_TEMP_0{$gate};
			$implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{1} = $circuitFaults_TEMP_1{$gate};
		}
	}
	###################################################################
	
	$newStuckAtSum = 0;
	$pathGain = 0;
	
	foreach $gate (nsort keys %circuitFaults_TEMP_0) {
		
		if ( (grep {$_ eq $gate} @primaryInputs) or $gate =~ m/>/ ) {
			next;
		}
		else {	
			$newStuckAtSum = $newStuckAtSum + $circuitFaults_TEMP_0{$gate} + $circuitFaults_TEMP_1{$gate};
			
			if ($flag==1) {
				print "$gate: sa0 = $circuitFaults_TEMP_0{$gate}, sa1 = $circuitFaults_TEMP_1{$gate}, S = ",$circuitFaults_TEMP_0{$gate}+$circuitFaults_TEMP_1{$gate},"\n";
			}		
		}	
	}
	
	$pathGain = $newStuckAtSum - $currentSAT;
	
	if ($flag==1) {

		print "\nFINAL-GATES: @sensQ\n\n";	
		# print Dumper \%movingImp; 	
		# print Dumper \%foTemp;
		# print Dumper \%reachability;				
		print Dumper \%inputs_TEMP;		
		print "currentSAT: $currentSAT, newSAT: $newStuckAtSum, Gain: $pathGain, IMP-TYPE: ",$implicationType{"$newSource:$newTarget"},"\n";
	}
		
	exit;
		
	return ($newStuckAtSum, $pathGain);
}
#######################################################

sub rankImplications {
	
	#Implications for a gates are ranked based on two factors.	
	#1. A gate's sensitivity i.e., stuck-at-0 and stuck-at-1 prob.
	#2. Area of a gate in terms of number of literals going through that gate.		
	
	$flag = 0;
	
	for $targetGate (sort keys %implications) {	
		for $sourceGate (sort keys %{ $implications{$targetGate} }) {
						
			# $sourceGate = "Lv13_D_8";
			# $targetGate = "v13_D_8";
			
			@impT = keys %{ $implications{$targetGate}{$sourceGate} };			
						
			# print "Source: $sourceGate, Target: $targetGate, IMP: @impT\n";
			# $cin=getc(STDIN);				
	
			# If both implications 1_0 and 0_1 exist then they are treated as 
			# different implications and path weight is computed separately for 
			# each one separately. 
			if (scalar @impT==2) { 
			
				my $s1 = (split("_", $impT[0]))[0];
				my $t1 = (split("_", $impT[0]))[1];
				
				$probHigh = 0;
				if ($t1 eq 0) {
					$probHigh = $circuitFaults_1{$targetGate};
				}
				else {
					$probHigh = $circuitFaults_0{$targetGate};
				}
				
				# print "$sourceGate(P$sourceImp: ",$gatesOPP{$sourceGate}{$sourceImp},"), $targetGate (PHigh: $probHigh), $PO, $impT[0] $impT[1]\n"; 
				# $cin=getc(STDIN);	
				
				if ($gatesOPP{$sourceGate}{$s1} >= 0.3 and $probHigh >= 0.4) {														
					@sat = stuckAtDue2Implication($sourceGate, $targetGate, $impT[0], $flag);																
					$implicationsSAT{"$sourceGate".":$s1;$targetGate".":$t1"} = $sat[0];
					$pathGain{"$sourceGate".":$s1;$targetGate".":$t1"} = $sat[1]*$scalingFactor;				
				}				
				
				my $s2 = (split("_", $impT[1]))[0];
				my $t2 = (split("_", $impT[1]))[1];
				
				$probHigh = 0;
				if ($t2 eq 0) {
					$probHigh = $circuitFaults_1{$targetGate};
				}
				else {
					$probHigh = $circuitFaults_0{$targetGate};
				}
				
				# print "$sourceGate(P$sourceImp: ",$gatesOPP{$sourceGate}{$sourceImp},"), $targetGate (PHigh: $probHigh), $PO, $impT[0] $impT[1]\n"; 
				# $cin=getc(STDIN);	
				
				if ($gatesOPP{$sourceGate}{$s2} >= 0.3 and $probHigh >= 0.4) {														
					@sat = stuckAtDue2Implication($sourceGate, $targetGate, $impT[1], $flag);															$implicationsSAT{"$sourceGate".":$s2;$targetGate".":$t2"} = $sat[0];										
					$pathGain{"$sourceGate".":$s2;$targetGate".":$t2"} = $sat[1]*$scalingFactor;
				}
			}
			else {		
				
				my $sourceImp = (split("_", $impT[0]))[0];
				my $targetImp = (split("_", $impT[0]))[1];
				
				$probHigh = 0;
				if ($targetImp eq 0) {
					$probHigh = $circuitFaults_1{$targetGate};
				}
				else {
					$probHigh = $circuitFaults_0{$targetGate};
				}
				
				# print "$sourceGate (P$sourceImp: ",$gatesOPP{$sourceGate}{$sourceImp},"), $targetGate (PHigh: $probHigh), $PO, $sourceImp, $targetImp\n"; 
				# $cin=getc(STDIN);	
				
				if ($gatesOPP{$sourceGate}{$sourceImp} >= 0.3 and $probHigh >= 0.4) {	
				
					@sat = stuckAtDue2Implication($sourceGate, $targetGate, $impT[0], $flag);
					$implicationsSAT{"$sourceGate;$targetGate"} = $sat[0];															
					$pathGain{"$sourceGate;$targetGate"} = $sat[1]*$scalingFactor;	
				}
				
				# print "$sat[0], $sat[1]\n";
				# exit;				
			}			
		}		
	}	

	
	# open (OUT_FILE, ">$inputFile.impEW") or die $!;	
	# print OUT_FILE Data::Dumper->Dump( [ \%implicationsWeight ], [ qw(IMPLICATIONS_WEIGHT) ] );		
	# close(OUT_FILE);
	# nstore \%implications, $inputFile.'.impW'; 
		
	@sortedPOF = ();
	foreach my $name (sort { $pathGain{$a} <=> $pathGain{$b} } keys(%pathGain) ) {			
		if ( $name !~ m/>/ and !(grep {$_ eq $name} @primaryInputs) ) {
			push @sortedPOF, $name;	
		}
	}
	
	# print Dumper \%pathGain;
				
	$counter = 1;	
	$IMP_POF = 0;
	$pGain = 0;
	open (OUT_FILE, ">$inputFile.stats") or die $!;	
	foreach $imp (@sortedPOF) {		

		@temp = split(";", $imp);
		
		# print "S & T: @temp\n";
						
		if ($imp =~ m/:/) {
			$sourceGate = (split(":", $temp[0]))[0];
			$targetGate = (split(":", $temp[1]))[0];			
			$id = $imp;
			
			$src_imp = (split(":", $temp[0]))[1];
			$targ_imp = (split(":", $temp[1]))[1];			
			$impl = $src_imp."_".$targ_imp;		
			
			$IMP_SAT = $implicationsSAT{$imp};
			$pGain = $pathGain{$imp};
			
			# print "ID: $imp, Source: $sourceGate, T: $targetGate, I: $impl\n";		
			# $cin=getc(STDIN);		
		}		
		else {
			$sourceGate = $temp[0];
			$targetGate = $temp[1];			
						
			@i1 = keys %{ $implications{$targetGate}{$sourceGate} };
			$src_imp = (split ("_", $i1[0]))[0];
			$targ_imp = (split ("_", $i1[0]))[1];
			$impl = $src_imp."_".$targ_imp;	
			
			$IMP_SAT = $implicationsSAT{$imp};	
			$pGain = $pathGain{$imp};	
			
			# print "ID: $imp, Source: $sourceGate, T: $targetGate, PO: $PO, I: $impl @i1, $IMP_POF, $pGain\n";		
			# $cin=getc(STDIN);	
		}		
		
		$probHigh = $gatesOPP{$sourceGate}{$src_imp};	
								
		if ($probHigh >= $probThreshold) {
			$implicationsToApply{$counter}{'source'}			=	$sourceGate;
			$implicationsToApply{$counter}{'target'}			=	$targetGate;
			$implicationsToApply{$counter}{'id'}				=	$imp;		
			$implicationsToApply{$counter}{'implication'}		=	$impl;
			$implicationsToApply{$counter}{'sat'}	 			=	$IMP_SAT;
			$implicationsToApply{$counter}{'pathGain'}	 		=	$pGain;		
			$implicationsToApply{$counter}{'type'}	 			=	$implicationType{"$sourceGate:$targetGate"};		
	
			if (-($pGain) < 0.02) {
				delete $implications{$targetGate}{$sourceGate};
			}
			else {
			
				printf (OUT_FILE "R$counter=> S: $sourceGate(P$src_imp: %0.4f), T: $targetGate, IMP: $impl, Orig-SAT: $currentSAT, NEW-SAT: %2.4f, PATH-GAIN: %2.4f, TYPE: %s\n\n", $probHigh, $implicationsToApply{$counter}{'sat'}*$scalingFactor, $implicationsToApply{$counter}{'pathGain'}, $implicationsToApply{$counter}{'type'});			
			}		
			
			$counter++;		
		}		
	}
	close(OUT_FILE);
		
	# print Dumper \%implicationPathGatesStuckAt;
	# exit;
}
#######################################################

sub updateImplications {
		
	for $targetGate (sort keys %implications) {	
		for $sourceGate (sort keys %{ $implications{$targetGate} }) {
			
			# $sourceGate = "g312";
			# $targetGate = "g293";
			# $PO = "v8_0";
			@imp = keys %{ $implications{$targetGate}{$sourceGate} };
									
			# print "Source: $sourceGate, Target: $targetGate, IMP: @imp\n"; 
			# $cin=getc(STDIN);
	
			# If both implications 1_0 and 0_1 exist then they are treated as 
			# different implications and path weight is computed separately for 
			# each one separately. 
			if (scalar @imp==2) { 
			
				# print "$sourceGate, $targetGate\n"; $cin=getc(STDIN);
				
				my $s1 = (split("_", $imp[0]))[0];
				my $t1 = (split("_", $imp[0]))[1];
				$impl1 = $s1."_".$t1;
				
				$probHigh1 = 0;
				if ($t1 eq 0) {
					$probHigh1 = $circuitFaults_1{$targetGate};
				}
				else {
					$probHigh1 = $circuitFaults_0{$targetGate};
				}
				
				my $s2 = (split("_", $imp[1]))[0];
				my $t2 = (split("_", $imp[1]))[1];
				$impl2 = $s2."_".$t2;
				
				$probHigh2 = 0;
				if ($t2 eq 0) {
					$probHigh2 = $circuitFaults_1{$targetGate};
				}
				else {
					$probHigh2 = $circuitFaults_0{$targetGate};
				}
														
				if (($implications{$targetGate}{$sourceGate}{$impl1} == 1) 
					and ($implications{$targetGate}{$sourceGate}{$impl2} == 0)
					and ($gatesOPP{$sourceGate}{$s1} >= 0.3 and $probHigh1 >= 0.4)) {
					
					@sat = stuckAtDue2Implication2($sourceGate, $targetGate, $impl1, 0);		
					$implicationsSAT{"$sourceGate".":$s1;$targetGate".":$t1"} = $sat[0];
					$pathGain{"$sourceGate".":$s1;$targetGate".":$t1"} = $sat[1]*$scalingFactor;
				}
				elsif (($implications{$targetGate}{$sourceGate}{$impl2} == 1) 
					and ($implications{$targetGate}{$sourceGate}{$impl1} == 0)
					and ($gatesOPP{$sourceGate}{$s2} >= 0.3 and $probHigh2 >= 0.4)) {
														
					@sat = stuckAtDue2Implication2($sourceGate, $targetGate, $impl2, 0);																		
					$implicationsSAT{"$sourceGate".":$s2;$targetGate".":$t2"} = $sat[0];
					$pathGain{"$sourceGate".":$s2;$targetGate".":$t2"} = $sat[1]*$scalingFactor;
				}
				elsif (($implications{$targetGate}{$sourceGate}{$impl1} == 1) 
					and ($implications{$targetGate}{$sourceGate}{$impl2} == 1)
					and ($gatesOPP{$sourceGate}{$s1} >= 0.3 and $probHigh1 >= 0.4)
					and ($gatesOPP{$sourceGate}{$s2} >= 0.3 and $probHigh2 >= 0.4)) {
						
					@sat = stuckAtDue2Implication2($sourceGate, $targetGate, $impl1, 0);												
					$implicationsSAT{"$sourceGate".":$s1;$targetGate".":$t1"} = $sat[0];
					$pathGain{"$sourceGate".":$s1;$targetGate".":$t1"} = $sat[1]*$scalingFactor;
						
					@sat = stuckAtDue2Implication2($sourceGate, $targetGate, $impl2, 0);																
					$implicationsSAT{"$sourceGate".":$s2;$targetGate".":$t2"} = $sat[0];
					$pathGain{"$sourceGate".":$s2;$targetGate".":$t2"} = $sat[1]*$scalingFactor;
				}
			}
			else {	

				my $sourceImp = (split("_", $imp[0]))[0];
				my $targetImp = (split("_", $imp[0]))[1];
				
				$probHigh = 0;
				if ($targetImp eq 0) {
					$probHigh = $circuitFaults_1{$targetGate};
				}
				else {
					$probHigh = $circuitFaults_0{$targetGate};
				}
				
				# print "$sourceGate (P$sourceImp: ",$gatesOPP{$sourceGate}{$sourceImp},"), $targetGate (PHigh: $probHigh), $PO, $sourceImp, $targetImp\n"; 
				# $cin=getc(STDIN);	
				
				if ($gatesOPP{$sourceGate}{$sourceImp} >= 0.3 and $probHigh >= 0.4) {				
					@sat = stuckAtDue2Implication2($sourceGate, $targetGate, $imp[0], 0);
					$implicationsSAT{"$sourceGate;$targetGate"} = $sat[0];															
					$pathGain{"$sourceGate;$targetGate"} = $sat[1]*$scalingFactor;	
				}
			}
		}
	}
		
	# open (OUT_FILE, ">$inputFile.impEW") or die $!;	
	# print OUT_FILE Data::Dumper->Dump( [ \%implicationsWeight ], [ qw(IMPLICATIONS_WEIGHT) ] );		
	# close(OUT_FILE);
	# nstore \%implications, $inputFile.'.impW'; 
		
	@sortedPOF = ();
	foreach my $name (sort { $pathGain{$a} <=> $pathGain{$b} } keys(%pathGain) ) {			
		if ( $name !~ m/>/ and !(grep {$_ eq $name} @primaryInputs) ) {
			push @sortedPOF, $name;	
		}
	}	
	
	$counter = 1;	
	$IMP_POF = 0;
	$pGain = 0;
	open (OUT_FILE, ">$inputFile.stats") or die $!;	
	foreach $imp (@sortedPOF) {		

		@temp = split(";", $imp);
		
		# print "S & T: @temp\n";
						
		if ($imp =~ m/:/) {
			$sourceGate = (split(":", $temp[0]))[0];
			$targetGate = (split(":", $temp[1]))[0];
			$id = $imp;
			
			$src_imp = (split(":", $temp[0]))[1];
			$targ_imp = (split(":", $temp[1]))[1];			
			$impl = $src_imp."_".$targ_imp;		
			
			$IMP_SAT = $implicationsSAT{$imp};
			$pGain = $pathGain{$imp};
			
			# print "ID: $imp, Source: $sourceGate, T: $targetGate, I: $impl\n";		
			# $cin=getc(STDIN);		
		}		
		else {
			$sourceGate = $temp[0];
			$targetGate = $temp[1];
									
			@i1 = keys %{ $implications{$targetGate}{$sourceGate} };
			$src_imp = (split ("_", $i1[0]))[0];
			$targ_imp = (split ("_", $i1[0]))[1];
			$impl = $src_imp."_".$targ_imp;	
						
			$IMP_SAT = $implicationsSAT{$imp};	
			$pGain = $pathGain{$imp};	
			
			# print "ID: $imp, Source: $sourceGate, T: $targetGate, I: $impl, $IMP_POF, $pGain\n";		
			# $cin=getc(STDIN);	
		}		
		
		$probHigh = $gatesOPP{$sourceGate}{$src_imp};	
								
		if ($probHigh >= $probThreshold) {
			$implicationsToApply{$counter}{'source'}			=	$sourceGate;
			$implicationsToApply{$counter}{'target'}			=	$targetGate;
			$implicationsToApply{$counter}{'id'}				=	$imp;		
			$implicationsToApply{$counter}{'implication'}		=	$impl;
			$implicationsToApply{$counter}{'sat'}	 			=	$IMP_SAT;
			$implicationsToApply{$counter}{'pathGain'}	 		=	$pGain;		
			$implicationsToApply{$counter}{'type'}	 			=	$implicationType{"$sourceGate:$targetGate"};		
	
			if (-($pGain) < 0.02) {
				delete $implications{$targetGate}{$sourceGate};
			}
			else {
			
				printf (OUT_FILE "R$counter=> S: $sourceGate(P$src_imp: %0.4f), T: $targetGate, IMP: $impl, Orig-SAT: $currentSAT, NEW-SAT: %2.4f, PATH-GAIN: %2.4f, TYPE: %s\n\n", $probHigh, $implicationsToApply{$counter}{'sat'}*$scalingFactor, $implicationsToApply{$counter}{'pathGain'}, $implicationsToApply{$counter}{'type'});			
			}		
			
			$counter++;		
		}		
	}
	close(OUT_FILE);
}
#######################################################

sub addImplication {
	my $source 	=	$_[0];
	my $target 	=	$_[1];
	my $implication = $_[2];
	my $impCount = $_[3];
	my $idI = $_[4];
	my $flag = 		$_[5];
	
	# $flag=1;
				
	my $sourceImp = (split("_", $implication))[0];
	my $targetImp = (split("_", $implication))[1];
	
	my $sourceGateType = (split("-", $inputs{$source}))[0];
	my $targetGateType = (split("-", $inputs{$target}))[0];	
	
	$newTarget = $target;
	$newSource = $source;
	
	####################################################################
	# COMPUTE AREA OVERHEAD DUE TO IMPLICATION WIRE ADDED
	####################################################################	
	$targetGateChangedFlag = 0;
	$maskingGateChangedFlag = 0;
	$maskingGate = $target;
	$maskingGateType = 0;

	$maskingGateType = (split("-", $inputs{$fanouts_TEMP{$target}}))[0];							
	$maskingGate = (split("-", $fanouts{$target}))[0];
	$sourceID = firstidx { $_ eq $source } @allGates;		
			
	if ($implication eq "0_0") {			
					
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NAND" or $maskingGateType eq "AND")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.
		if ($maskingGateChangedFlag==1) {							
									
			$newArea += ($nmosDrainArea + $pmosDrainArea);
			
			if ($maskingGateType eq "NOT") {				
				$inputs{$maskingGate} = "NAND-$target-$source";							
			}
			elsif ($maskingGateType eq "NAND" or $maskingGateType eq "AND") {				
				$inputs{$maskingGate} .= "-$source";			
			}
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NOR" or $maskingGateType eq "OR") {
								
			if ($targetGateType eq "NOT") {	
				$input2TargetGate = (split("-", $inputs{$target}))[1];															
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$target} = "NOR-$input2TargetGate-$in2NOT";	
					$newSource = $in2NOT;					
				}
				else {
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);		
					
					$inputs{"IMP1_$impCount"} = "NOT-$source";				
					$inputs{$target} = "NOR-$input2TargetGate-IMP1_$impCount";
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";	
					
					$circuitFaults_0{"IMP1_$impCount"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
						else {					
							$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
					}
					else {														
						$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_0{$source};
					}
				}
			}
		
			elsif ($targetGateType eq "NOR") {	
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$target} .= "-$in2NOT";	
					$newSource = $in2NOT;
				}				
				else {
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);
					
					$inputs{"IMP1_$impCount"} = "NOT-$source";
					$inputs{$target} .= "-IMP1_$impCount";	
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";

					$circuitFaults_0{"IMP1_$impCount"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
						else {					
							$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
					}
					else {					
						$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_0{$source};				
					}
				}
			}
			
			elsif ($targetGateType eq "AND") {	
				$newArea += ($nmosDrainArea + $pmosDrainArea);				
				$inputs{$target} .= "-$source";					
			}
			
			elsif ($targetGateType eq "NAND" or $targetGateType eq "OR") {							
				print "CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
			}
		}						
	}	
	
	elsif ($implication eq "0_1") {	
					
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NOR" or $maskingGateType eq "OR")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.
		if ($maskingGateChangedFlag==1) {
			
			if ($maskingGateType eq "NOT") {
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$maskingGate} = "NOR-$target-$in2NOT";	
					$newSource = $in2NOT;					
				}			
				else {
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);	
						
					$inputs{"IMP1_$impCount"} = "NOT-$source";				
					$inputs{$maskingGate} = "NOR-$target-IMP1_$impCount";	
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";

					$circuitFaults_0{"IMP1_$impCount"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
						else {					
							$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
					}
					else {					
						$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_0{$source};
					}
				}
			}
			
			elsif ($maskingGateType eq "NOR" or $maskingGateType eq "OR") {		
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$maskingGate} .= "-$in2NOT";
					$newSource = $in2NOT;
				}				
				else {
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);
					
					$inputs{"IMP1_$impCount"} = "NOT-$source";
					$inputs{$maskingGate} .= "-IMP1_$impCount";	
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";

					$circuitFaults_0{"IMP1_$impCount"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
						else {					
							$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
					}
					else {					
						$circuitFaults_1{"IMP1_$impCount"} = $circuitFaults_0{$source};				
					}
				}
			}
		}
	
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NAND" or $maskingGateType eq "AND") {			
			
			if ($targetGateType eq "NOT") {			
				$newArea += ($nmosDrainArea + $pmosDrainArea);
				
				$input2TargetGate = (split("-", $inputs{$target}))[1];															
				$inputs{$target} = "NAND-$input2TargetGate-$source";		
			}
			
			elsif ($targetGateType eq "NAND") {	
				$newArea += ($nmosDrainArea + $pmosDrainArea);
				$inputs{$target} .= "-$source";				
			}
			
			elsif ($targetGateType eq "OR" ) {			
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$target} .= "-$in2NOT";	
					$newSource = $in2NOT;					
				}				
				else {
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);
					
					$inputs{"IMP1_$impCount"} = "NOT-$source";
					$inputs{$target} .= "-IMP1_$impCount";	
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";					

					$circuitFaults_1{"IMP1_$impCount"} = 0;

					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
						else {					
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
					}
					else {						
						$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$source};				
					}				
				}
			}
			
			elsif ($targetGateType eq "NOR" or $targetGateType eq "AND") {							
				print "CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
			}			
		}						
	}
	
	elsif ($implication eq "1_0") {	
						
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NAND" or $maskingGateType eq "AND")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.
		if ($maskingGateChangedFlag==1) {
					
			if ($maskingGateType eq "NOT") {	
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$maskingGate} = "NAND-$target-$in2NOT";	
					$newSource = $in2NOT;
				}				
				
				else {
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);
					
					$inputs{"IMP1_$impCount"} = "NOT-$source";				
					$inputs{$maskingGate} = "NAND-$target-IMP1_$impCount";	
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";
					
					$circuitFaults_1{"IMP1_$impCount"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
						else {					
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
					}
					else {								
						$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$source};
					}
				}
			}
		
			elsif ($maskingGateType eq "NAND" or $maskingGateType eq "AND") {	
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$maskingGate} .= "-$in2NOT";
					$newSource = $in2NOT;
				}				
				else {
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);
					
					$inputs{"IMP1_$impCount"} = "NOT-$source";
					$inputs{$maskingGate} .= "-IMP1_$impCount";	
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";				

					$circuitFaults_1{"IMP1_$impCount"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
						else {					
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
					}
					else {						
						$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$source};				
					}
				}
			}
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NOR" or $maskingGateType eq "OR") {			
			
			if ($targetGateType eq "NOT") {							
				$newArea += ($nmosDrainArea + $pmosDrainArea);
				
				$input2TargetGate = (split("-", $inputs{$target}))[1];				
				$inputs{$target} = "NOR-$input2TargetGate-$source";								
			}
			
			elsif ($targetGateType eq "NOR") {			
				$newArea += ($nmosDrainArea + $pmosDrainArea);
				$inputs{$target} .= "-$source";			
			}
			
			elsif ($targetGateType eq "AND") {	
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$target} .= "-$in2NOT";	
					$newSource = $in2NOT;
				}				
				else {
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);
					
					$inputs{"IMP1_$impCount"} = "NOT-$source";
					$inputs{$target} .= "-IMP1_$impCount";		
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";

					$circuitFaults_1{"IMP1_$impCount"} = 0;

					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
						else {					
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
					}
					else {						
						$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$source};				
					}	
				}
			}
		
			elsif ($targetGateType eq "NAND" or $targetGateType eq "OR") {							
				print "CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
			}
		}						
	}
		
	elsif ($implication eq "1_1") {	
		
		if ( !(grep {$_ eq $target} @multiFanOuts) and !(grep {$_ eq $target} @primaryOutputs)
			 and ($maskingGateType eq "NOT" or $maskingGateType eq "NOR" or $maskingGateType eq "OR")) {					
			$maskingGateChangedFlag = 1; 
			$newTarget = $maskingGate;
			$tempTargetGateType = (split("-", $inputs{$newTarget}))[0];
		}
		else {		
			$targetGateChangedFlag = 1;
			$tempTargetGateType = $targetGateType;
		}
		
		# The redundant wire will be injected to the MASKING gate (GATE FED BY THE TARGET GATE)
		# only when TARGET gate doesn't fanout to multiple gates. Otherwise, the redundant
		# wire is injected in the target gate.				
		if ($maskingGateChangedFlag==1) {			
						
			$newArea += ($nmosDrainArea + $pmosDrainArea);	
			
			if ($maskingGateType eq "NOT") {
				$inputs{$maskingGate} = "NOR-$target-$source";		
			}
		
			elsif ($maskingGateType eq "NOR" or $maskingGateType eq "OR") {
				$inputs{$maskingGate} .= "-$source";			
			}
		}
		
		#FRW is added to the target gate only here.
		elsif($targetGateChangedFlag==1 or $maskingGateType eq "NAND" or $maskingGateType eq "AND") {	
											
			if ($targetGateType eq "NOT") {			
			
				$input2TargetGate = (split("-", $inputs{$target}))[1];	
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);	
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$target} = "NAND-$input2TargetGate-$in2NOT";
					$newSource = $in2NOT;
				}
				else {
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);		
					
					$inputs{"IMP1_$impCount"} = "NOT-$source";
					$inputs{$target} = "NAND-$input2TargetGate-IMP1_$impCount";	
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";

					$circuitFaults_1{"IMP1_$impCount"} = 0;
					
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
						else {					
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
					}
					else {					
						$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$source};
					}
				}
			}		
		
			elsif ($targetGateType eq "NAND") {
				
				if ($sourceGateType eq "NOT") {
					$newArea += ($nmosDrainArea + $pmosDrainArea);
					
					$in2NOT = (split("-", $inputs{$source}))[1];
					$inputs{$target} .= "-$in2NOT";	
					$newSource = $in2NOT;
				}
				else {	
					$newArea += (2*$nmosDrainArea + 2*$pmosDrainArea);
					
					$inputs{"IMP1_$impCount"} = "NOT-$source";
					$inputs{$target} .= "-IMP1_$impCount";
					splice @allGates, $sourceID+1, 0, "IMP1_$impCount";
						
					$circuitFaults_1{"IMP1_$impCount"} = 0;
				
					if (grep {$_ eq $source} @primaryInputs) {
						if ($tempTargetGateType eq "NOT" or $tempTargetGateType eq "NAND" or $tempTargetGateType eq "NOR") {
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$target};
						}
						else {					
							$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_0{$target};
						}
					}
					else {					
						$circuitFaults_0{"IMP1_$impCount"} = $circuitFaults_1{$source};
					}
				}					
			}
			
			elsif ($targetGateType eq "OR") {
				$newArea += ($nmosDrainArea + $pmosDrainArea);			
				$inputs{$target} .= "-$source";					
			}
			
			elsif ($targetGateType eq "NOR" or $targetGateType eq "AND") {							
				print "CANNOT HAPPEN.....CHECK CAREFULLY AGAIN\n";
			}
		}						
	}			
	####################################################################
		
	##################################################################
	#Construct the Bench file after applying each implication
	########################################### #######################		
	@circuit = ();
	open (OUT, ">$origFileName"."_IMP$impCount.bench");
		
	print OUT "\n";
	print OUT "# $origFileName"."_IMP$impCount\n";
	print OUT "# ",scalar @primaryInputs," inputs\n";
	print OUT "# ",scalar @primaryOutputs," outputs\n";
	print OUT "\n";
	
	push @circuit, "\n";
	foreach $k(0..scalar @primaryInputs - 1) {
		print OUT "INPUT($primaryInputs[$k])\n";
		push @circuit, "INPUT($primaryInputs[$k])\n";
	}
	print OUT "\n";
	push @circuit, "\n";
	
	foreach $k(0..scalar @primaryOutputs - 1) {
		print OUT "OUTPUT($primaryOutputs[$k])\n";
		push @circuit, "OUTPUT($primaryOutputs[$k])\n";
	}
	print OUT "\n";
	push @circuit, "\n";
	
	foreach $gate (@allGates) {	

		@row = split("-", $inputs{$gate});											
						
		my @conString = ();
		
		my $a = "$gate = $row[0](";
		print OUT "$gate = $row[0](";
		for ($ii = 1; $ii < scalar @row; $ii++) {																					
			push @conString, $row[$ii];					
		}
		
		$string = join(", ", @conString);					
		print OUT "$string)\n";
		
		$a .= "$string)\n";
		push @circuit, $a;
		
		
		if (grep {$_ eq $gate} @primaryOutputs) {
			print OUT "\n";
			push @circuit, "\n";
		}		
	}
	
	close (OUT);
	system("dos2unix $origFileName"."_IMP$impCount.bench");					
	#--------------------------------------------------------------------------------------------------------------			
	
	$inputFile = $origFileName."_IMP$impCount";
	readBenchFile_MEM_2_MEM();
	print "\n--Finished Reading $inputFile ...\n";
	##############################################################################################################				
	
	# print Dumper \%path;
	
	if ($flag==1) {
		print "==>SOURCE: $source (P$sourceImp: $gatesOPP{$source}{$sourceImp}), N-S: $newSource, A-T: $target, N-T: $newTarget, M-G: $maskingGate ($maskingGateType, $maskingGateChangedFlag), T-FLAG: $targetGateChangedFlag, IMP: $implication, Area: $newArea\n"; 
		# $cin=getc(STDIN); 
	}
	
	
	# $impPathGates = ();
	@ik = ();	
	push @ik, $newSource;
		
	foreach $gate (nsort keys %{ $implicationPathGatesStuckAt{$newSource.":".$newTarget} } ) {	
	
		$circuitFaults_0{$gate} = $implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{0};
		$circuitFaults_1{$gate} = $implicationPathGatesStuckAt{$newSource.":".$newTarget}{$gate}{1};												
						
		push @ik, $gate;
	}
	
	push @ik, $newTarget;	
	@ik = reverse @ik;
	
	
	######################################################################
	# DELETE EQUIVALENT IMPLICATIONS
	######################################################################
	print "IK: @ik \n";			
	my @combinations = combine(2, @ik);
	my @combinations = map { join ":", @$_ } @combinations;
		
	foreach $comb (@combinations) {
		
		@t = split(":", $comb);
				
		$source1 = $t[0];
		$target1 = $t[1];
		
		if ( exists($implications{$target1}) and exists($implications{$target1}{$source1}) ) {
			
			$srcIMP = $implicationPathGatesMovingImp{$newSource.":".$newTarget}{$source1};
			$targIMP = $implicationPathGatesMovingImp{$newSource.":".$newTarget}{$target1};
			
			$impl = $srcIMP."_".$targIMP;
						
			print "DELETE IMPLICATION $target1:$source1 ==> $impl \n";				
			delete $implications{$target1}{$source1};
			$implicationsRemoved{$target1.":".$source1} = $impl;						
		}		
		
		$target2 = $t[0];
		$source2 = $t[1];
		
		if ( exists($implications{$target2}) and exists($implications{$target2}{$source2}) ) {
			
			$srcIMP = $implicationPathGatesMovingImp{$newSource.":".$newTarget}{$source2};
			$targIMP = $implicationPathGatesMovingImp{$newSource.":".$newTarget}{$target2};
			
			$impl = $srcIMP."_".$targIMP;
						
			print "DELETE IMPLICATION $target2:$source2 ==> $impl \n";				
			delete $implications{$target2}{$source2};
			$implicationsRemoved{$target2.":".$source2} = $impl;						
		}	
	}
	######################################################################
		
	$stuckAtSum1 = 0;	
	foreach $k (sort keys %circuitFaults_0) {	
		if ( (grep {$_ eq $k} @primaryInputs) or $k =~ m/>/ ) {
			next;
		}
		else {
			$stuckAtSum1 = $stuckAtSum1 + $circuitFaults_0{$k} + $circuitFaults_1{$k};
			# print "$k: $circuitFaults_0{$k}, $circuitFaults_1{$k}\n";
		}
	}
	# exit;
	
	return $stuckAtSum1;
}
#######################################################

sub applyImplications {

	$totalImplications = keys %implicationsToApply;
	my $isFullyProtected			= 	0;
	my $protected4SameImplication	=	0;
	my $fanOutFlag = 0;
	my $alreadyProtectedGateFound = 0;
	my $protectTheGateFlag = 1;
	my $numberOfImplicationsApplied = 0;		
	my $newStuckAtSum = 0;
	my $previousStuckAtSum = 0;
	
	open (IMP_LOG, ">$inputFile".".pofs") or die $!; 
	print IMP_LOG "$inputFile\n";
	print IMP_LOG "Init-Area: $origArea, Init-SAT: ",$origStuckAtSum*$scalingFactor,"\n";
	print IMP_LOG "----------------------------------------------------------------\n";
	
	open (IMP_LOG2, ">$inputFile".".log") or die $!; 
	
	$nextImplication = 1;
	$impApplied = 0;
	$impCount = 1;
	$prevSAT = $origStuckAtSum;
	
	foreach $impCount (1..$totalImplications) {
					
		$protectTheGateFlag = 0;								
		$impCount = $nextImplication;
						
		$sourceI = $implicationsToApply{$impCount}{'source'};
		$targetI = $implicationsToApply{$impCount}{'target'};		
		$implicationI = $implicationsToApply{$impCount}{'implication'};
		$pathGainI = $implicationsToApply{$impCount}{'pathGain'};
		$idI = $implicationsToApply{$impCount}{'id'};
		$typeI = $implicationType{"$sourceI:$targetI"};
		
		$maskingGate = (split("-", $fanouts{$targetI}))[0];		
		
		$src_impI = (split ("_", $implicationI))[0];
		$targ_impI = (split ("_", $implicationI))[1];
		
		print "\nIMP$impApplied","_$impCount: S: $sourceI, T: $targetI, IMP: $implicationI, P-GAIN: $pathGainI, id: $idI, Type: $typeI, SRC-IMP: $src_impI, TRG-IMP: $targ_impI, M-GATE: $maskingGate\n";
		print IMP_LOG2 "\nIMP$impApplied","_$impCount: S: $sourceI, T: $targetI, IMP: $implicationI, P-GAIN: $pathGainI, id: $idI, SRC-IMP: $src_impI, TRG-IMP: $targ_impI\n"; 
				
		if ($pathGainI < 0) {	
		
			if ( exists($combLoop{"$sourceI-$targetI"}) ) { 
				
				$protectTheGateFlag = 0;
			}
			else {
				$protectTheGateFlag = 1;
			}	
					 
			# $protectTheGateFlag = 1;			
			print "..Prot: $protectTheGateFlag, IMP: $implicationI, GL-$sourceI: $gateLevel{$sourceI}, GL-$targetI: $gateLevel{$targetI}\n\n";	
			print IMP_LOG2 "..Prot: $protectTheGateFlag, IMP: $implicationI, GL-$sourceI: $gateLevel{$sourceI}, GL-$targetI: $gateLevel{$targetI}\n\n";				
												
			if ($protectTheGateFlag==1) { 

				$impCount = $impApplied + 1;

				$start_timex = [Time::HiRes::gettimeofday()];
				$currentSAT = addImplication($sourceI, $targetI, $implicationI, $impCount, $idI, 0);									
				$run_timex = Time::HiRes::tv_interval($start_timex);
				$timeToAddImplicationOnly += $run_timex;
				print "\n--Finished Applying IMP $impCount ...NEW SAT: $currentSAT\n";
				
				# $cin=getc(STDIN); 
				# exit;
												
				%pathGain = ();
				%implicationPathGates = ();
				%implicationPathGatesStuckAt = ();
				%implicationPathGatesMovingImp = ();				
				
				$numberOfImplicationsApplied += 1;
				
				#update implications					
				updateImplications();				
				print "--Updated Implications of $inputFile ...\n";
				print IMP_LOG2 "--Updated Implications of $inputFile ...\n";
				# $cin=getc(STDIN); exit;
								
				print "\n----------------------------------------------------\n";
				$impApplied++;
				$nextImplication=1;
				
												
				#___________________________________________________________________________________________________________
				# COMPUTE STUCK-AT USING HOPE
				#___________________________________________________________________________________________________________
				$hopeSAT = 1;
				# system("hope -t t.test -D -N $origFileName"."_IMP$impCount.bench -l $origFileName"."_IMP$impCount.fault");
				# system("perl integrated-algos.pl $origFileName"."_IMP$impCount $numberOfPrimaryInputs");	
				# open(SAT, "sat.log") or die $!;				
				# while(<SAT>) {
					# chomp;
					# $hopeSAT = $_;
				# }
				# close(SAT);
				#___________________________________________________________________________________________________________
				
				$errorMargin = ( ($currentSAT - $hopeSAT)/$hopeSAT) * 100;
				
				printf IMP_LOG "$impApplied: Area: %4.2f, Inc: %4.2f%%, C-SAT: %1.4f, HOPE: %4.4f, G: %1.4f, Err: %2.2f% ($sourceI [P$src_impI: %1.4f], $targetI [P$targ_impI: %1.4f], $implicationI, $gateBelongings{$targetI}, $typeI)\n",$newArea,(($newArea/$origArea)-1)*100,$currentSAT*$scalingFactor, $hopeSAT, ($currentSAT-$prevSAT)*$scalingFactor,  $errorMargin, $gatesOPP{$sourceI}{$src_impI}, $gatesOPP{$targetI}{$targ_impI};
				
				if ( ($prevSAT - $currentSAT)  < 0.02) {
					# print "$currentSAT greater thatn $prevSAT\n";
					print "Gain less than 0.02 ... \n";
					last;
				}
								
				$prevSAT = $currentSAT;	

				# if ($impCount==200) {
					# exit;
				# }
			}
			
			else {
				# print "HERE...\n";
				$nextImplication++;
				# print Dumper \%masterInputs; exit;
				# $cin=getc(STDIN); 
				# if ($impCount==2) {	exit;	}							
			}				
		}	
		else {
			$nextImplication++;
		}	
	}	
		
	
	# print Dumper \%combLoop;
	# print "@allGates ";
		
	printf ("\nInit-SAT: %2.4f, FINAL SAT: %2.4f, Orig-Area: %6.4f, NEW-Area: %6.4f, Increase: %6.2f%%\n", $origStuckAtSum*$scalingFactor,$currentSAT*$scalingFactor, $origArea, $newArea, (($newArea/$origArea)-1)*100);		
	print "Number of Applied Implications: $numberOfImplicationsApplied\n";
	print "Total Implications: $totalImplications\n";	
	
	printf (IMP_LOG2 "\nInit-SAT: %2.4f, FINAL SAT: %2.4f, Orig-Area: %6.4f, NEW-Area: %6.4f, Increase: %6.2f%%\n", $origStuckAtSum*$scalingFactor,$currentSAT*$scalingFactor, $origArea, $newArea, (($newArea/$origArea)-1)*100);			
	print IMP_LOG2 "Number of Applied Implications: $numberOfImplicationsApplied\n";
	print IMP_LOG2 "Total Implications: $totalImplications\n";
	
	# print "Applied Implication #:	@implicationsApplied\n";	
	# print Dumper \%gateLevel;
	
	close (IMP_LOG2);
	close (IMP_LOG);
}
#######################################################


#-----------------------------------------------
#		Main Program
#-----------------------------------------------

$cwd = getcwd; 				#get Current Working Directory
$inputFile	=	$ARGV[0];	

$origFileName = $inputFile;
$newFile = $inputFile."-FO.bench";
$probThreshold = 0;


#-----------------------------------------------
#		Variables Initialization
#-----------------------------------------------
$numberOfPrimaryInputs = 0;
$numberOfPrimaryOutputs = 0;
$numberOfCombGates = 0;
$numberOfFF = 0;
$numberOfLevels = 0;
$numberOfCollapsedFaults = 0;
$numberOfDetectedFaults = 0;
$numberOfUndetectedFaults = 0;
$faultCoverage = 0;

@primaryOutputs = ();
@primaryInputs = ();
@inter_IO_Gates = ();
@allGates = ();
@multiFanOuts = ();
@sortedPOF = ();
@circuit = ();
@allOutputs = ();

%circuitFaults_TEMP_0 = ();
%circuitFaults_TEMP_1 = ();
%inputs_TEMP =  ();
%fanouts_TEMP =  ();

%newlyAddedGates = ();
%poIndices = ();
%inputs = ();
%fanouts = ();
%subCKTFanouts = (); #Computed in RFOL Function
%subCKTFanoutCounter = (); #Computed in RFOL Function
%fanoutCounter = ();
%FOL = ();
%RFOL = ();
%FOLmap = ();
%gateLevel = ();
%sensQs = ();
$levelCounter = 0;
%path = ();
%exc = ();
%reachability = ();
$invertedInputs = 0;

%completeGates = ();
%gatesCounter = ();
%highProbGates = ();
%gateBelongings = (); # The hash structure to save for each gate its terminal PO.
%pathGain = ();

%implications = ();
%implicationsToApply = ();
%implicationPathGates = ();
%implicationPathGatesStuckAt = ();
%implicationPathProtected = ();
%implicationPathGatesMovingImp = ();
%implicationsRemoved = ();


$scalingFactor = 1;
$initialPOF = 0;
$currentSAT = 0;
$prevSAT = 0;
$origArea = 0;
$newArea = 0;
$nmosDrainArea = 0.26;
$pmosDrainArea = 0.52;	

# A hash of hash structure to store count of each input pattern for every gate.
%gateStatistics = (); 
%gateStatistics_averaged = ();

#_______________________________________________________________________________________________
%circuitFaults_0 = %{retrieve($inputFile.'_sa0.prob')};
%circuitFaults_1 = %{retrieve($inputFile.'_sa1.prob')};
%gatesOPP = %{retrieve($inputFile.'.opp')};

%implications    = %{retrieve($inputFile.'.impX')}; 
%FOL    = %{retrieve($inputFile.'.FOL')}; 
%RFOL    = %{retrieve($inputFile.'.RFOL')};
%gateLevel = %{retrieve($inputFile.'.level')};
# _______________________________________________________________________________________________

readBenchFile();
$numberOfPrimaryInputs = scalar @primaryInputs;
$numberOfPrimaryOutputs = scalar @primaryOutputs;

if ($numberOfPrimaryInputs > 20) {
	$numberOfTestVectors = 1000000;	
}

else {
	$numberOfTestVectors = 2**$numberOfPrimaryInputs;	
}

# createBenchFileWithAllNetsAsOutputs();
# system("perl gen_rnd_vecs.pl $numberOfPrimaryInputs $inputFile");
# system("hope -t $inputFile.test $newFile -l $inputFile-FO.fault");
# computeStatisticsFromFaultFile();
# nstore \%gateStatistics_averaged, $inputFile.'.opp'; 
# print Dumper \%gateStatistics_averaged; 
# # exit;

##########################################################################
# NORMALIZE STUCK AT FAULTS
##########################################################################
foreach $gate (sort keys %circuitFaults_0) {
	$circuitFaults_0{$gate} = $circuitFaults_0{$gate}/$numberOfTestVectors;
	$circuitFaults_1{$gate} = $circuitFaults_1{$gate}/$numberOfTestVectors;	
}
$numberOfTestVectors = 1;
#############################################################

%highProbGatesCounter = ();
for $gate ( keys %gatesOPP ) {		
	for $vector ( keys %{ $gatesOPP{$gate} } ) {			
		if ($gatesOPP{$gate}{$vector} >= 0) {
			$highProbGates{$gate}{$vector} = $gatesOPP{$gate}{$vector};
			$highProbGates{$gate}{"PO"} = $gateBelongings{$gate};
			$highProbGatesCounter{$gateBelongings{$gate}} += 1;
		}
		$gateStatistics_averaged{$gate}{$vector} = $gatesOPP{$gate}{$vector};
	}
}	
# print Dumper \%highProbGates; exit;

open (TIME_LOG, ">$inputFile.time") or die $!;
print TIME_LOG "Time LOG of $inputFile .... \n";
my $start_time = [Time::HiRes::gettimeofday()];

# my $start_time1 = [Time::HiRes::gettimeofday()];
# print TIME_LOG "\n--Extracting Subcircuits .... \n";
# # extractSubCircuits(); 	
# extractSubCircuits_FULLCIRCUIT(); 	
# my $run_time1 = Time::HiRes::tv_interval($start_time1);
# print TIME_LOG "--Extracting Subcircuit took $run_time1 sec.\n\n"; 

# $start_time1 = [Time::HiRes::gettimeofday()];
# print TIME_LOG "--Finding Implications .... \n";
# # findImplicationsForExtractedCircuit_CONE_METHOD(); 
# findImplicationsForExtractedCircuit_FULLCIRCUIT(); 
# $run_time1 = Time::HiRes::tv_interval($start_time1);
# print TIME_LOG "--Finding Implications took $run_time1 sec.\n\n";
# # print Dumper \%gatesOPP;
# exit;

####################################################################################
#	COMPUTE INITIAL POF AND AREA OF CIRCUIT
####################################################################################
$start_time1 = [Time::HiRes::gettimeofday()];
print TIME_LOG "--Computing Initial Stuck-AT SUM AND AREA of $inputFile .... \n";

system("perl bench_to_spice_130nm.pl $inputFile 1");
open (IN, "area.sp") or die $!;
$origArea = 0;
while(<IN>) {
	chomp;
	$origArea = $_;	
}

$origStuckAtSum = 0;	
foreach $k (nsort keys %circuitFaults_0) {
	
	if ( (grep {$_ eq $k} @primaryInputs) or $k =~ m/>/ ) {
		next;
	}
	else {	
		# print "$k: sa0 = $circuitFaults_0{$k}, sa1 = $circuitFaults_1{$k}, S = ",$circuitFaults_0{$k}+$circuitFaults_1{$k},"\n";
		$origStuckAtSum += $circuitFaults_0{$k} + $circuitFaults_1{$k};
	}
}
print "\nInitial Area: $origArea, Stuck-AT SUM: ",$origStuckAtSum,"\n";
print "*****************************************************\n\n"; 
$origArea_TEMP = $origArea;
$newArea = $origArea;
$currentSAT = $origStuckAtSum;
$prevSAT = $origStuckAtSum;
$run_time1 = Time::HiRes::tv_interval($start_time1);
print TIME_LOG"--Computing Initial POF AND AREA took $run_time1 sec.\n\n"; 
#####################################################################################

$start_time1 = [Time::HiRes::gettimeofday()];
print TIME_LOG "--Ranking Implications .... \n";
rankImplications(); 
$run_time1 = Time::HiRes::tv_interval($start_time1);
print TIME_LOG"--Ranking Implications took $run_time1 sec.\n\n"; 


$timeToAddImplicationOnly = 0;
$start_time1 = [Time::HiRes::gettimeofday()];
print TIME_LOG "--Applying Implications .... \n";
applyImplications();
$run_time1 = Time::HiRes::tv_interval($start_time1);
print TIME_LOG"--Applying Implications took $run_time1, $timeToAddImplicationOnly sec.\n\n"; 

my $run_time = Time::HiRes::tv_interval($start_time);
print TIME_LOG "-->Total Time taken = $run_time sec.\n\n";	

close(TIME_LOG);


# print Dumper \%implicationsRemoved;