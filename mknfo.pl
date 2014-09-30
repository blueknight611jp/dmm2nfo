use Web::Scraper;
use URI;

if(!@ARGV) {
	print "Usage: mknfo moviename\n";
	exit;
}
$file = $ARGV[0];
print "now processing $file\n";

@sp = split(/\./,$file);
$searchWord = $sp[0];
@sp = split(/-/,$searchWord);
$searchWord = "$sp[0]-$sp[1]";

print "searching $searchWord\n";


#$searchWord =~ /^(.*)-(.*)-+.*$/;
#$searchWord = "$1-$2";
#print "searching $searchWord\n";

# http://www.dmm.co.jp/search/=/searchstr=ADN-033

my $searchUrl = "http://www.dmm.co.jp/search/=/searchstr=$searchWord";
print "$searchUrl\n";
