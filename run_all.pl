#! /usr/bin/perl -w
use Cwd;

$start = time;
$cwd = getcwd; #get Current Working Directory

@circuits = qw (	
s298f
s344f
s386f
s444f
s510f
s526f
s641f
s713f
s820f
s832f
s953f
s1196f
s1238f
s1423f
s1488f
s1494f

			   );
			   
	
foreach $i (0..scalar @circuits - 1) {		

	# print "\nProcessing $circuits[$i]...\n";
	system("perl implications.pl $circuits[$i]");				
	# system("perl bench_to_spice_130nm.pl $circuits[$i]");				
	
}

$end = time;
$diff = $end - $start;
print "---Time taken by Conversion Process = $diff \n";
				
	