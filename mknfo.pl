use Web::Scraper;
use Encode;
use URI;
use DDP;

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

my $searchUrl = "http://www.dmm.co.jp/search/=/searchstr=$searchWord/view=text/";
print "$searchUrl\n";


my $uri = URI->new("$searchUrl");
my $scraper = scraper {
     process "/html/body/table/tr/td[2]/div/div[1]/div[2]/div/table/tr[2]/td[1]/p[1]/a",'list' => 'HTML';
};
my $res = $scraper->scrape($uri);

my $out = encode('utf-8',$res->{list});
 
print "$out\n";



