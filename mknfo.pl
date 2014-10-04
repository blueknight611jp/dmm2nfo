use Web::Scraper;
use Encode;
use URI;
use LWP::Simple;
#use DDP;

if(!@ARGV) {
	print "Usage: mknfo moviename\n";
	exit;
}
$file = $ARGV[0];
#print "now processing $file\n";

@sp = split(/\./,$file);
$searchWord = $sp[0];
@sp = split(/-/,$searchWord);
$searchWord = "$sp[0]-$sp[1]";

#print "searching $searchWord\n";


#$searchWord =~ /^(.*)-(.*)-+.*$/;
#$searchWord = "$1-$2";
#print "searching $searchWord\n";

# http://www.dmm.co.jp/search/=/searchstr=ADN-033
# http://www.dmm.co.jp/search/=/searchstr=adn-021/analyze=V1EBDVcGUQA_/n1=FgRCTw9VBA4GCF5WXA__/n2=Aw1fVhQKX19XC15nV0AC/sort=ranking/view=text/

my $searchUrl = "http://www.dmm.co.jp/search/=/searchstr=$searchWord/n1=FgRCTw9VBA4GCF5WXA__/n2=Aw1fVhQKX19XC15nV0AC/sort=ranking/view=text/";
#print "$searchUrl\n";


my $uri = URI->new("$searchUrl");
my $scraper = scraper {
     process "/html/body/table/tr/td[2]/div/div[1]/div[2]/div/table/tr[2]/td[1]/p[1]/a",'title' => 'HTML';
     process "/html/body/table/tr/td[2]/div/div[1]/div[2]/div/table/tr[2]/td[1]/p[1]/a",'test' => '@href';
};
my $res = $scraper->scrape($uri);

my $title = encode('utf-8',$res->{title});
my $target = $res->{test};
 
#print "$target : $title\n";

# http://www.dmm.co.jp/mono/dvd/-/detail/=/cid=adn033/

my $uri = URI->new("$target");
my $scraper = scraper {
		process "/html/body/table/tr/td[2]/div[1]/table/tr/td[1]/table/tr[2]/td[2]",'year'=>'TEXT';
		process "/html/body/table/tr/td[2]/div[1]/table/tr/td[1]/table/tr[3]/td[2]",'runtime'=>'TEXT';
		process "/html/body/table/tr/td[2]/div[1]/table/tr/td[1]/table/tr[4]/td[2]/span/a",'actor[]'=>'HTML';
		process "/html/body/table/tr/td[2]/div[1]/table/tr/td[1]/table/tr[4]/td[2]/span/a",'actid[]'=>'@href';
		process "/html/body/table/tr/td[2]/div[1]/table/tr/td[1]/table/tr[5]/td[2]/a",'director'=>'TEXT';
		process "/html/body/table/tr/td[2]/div[1]/table/tr/td[1]/table/tr[7]/td[2]/a",'studio'=>'TEXT';
		process "/html/body/table/tr/td[2]/div[1]/table/tr/td[1]/div[4]/p",'plot'=>'TEXT';
		process "/html/body/table/tr/td[2]/div[1]/table/tr/td[1]/div[1]/div/div[1]/a[1]/img",'thumb'=>'@src';
		process "/html/body/table/tr/td[2]/div[1]/table/tr/td[1]/div[1]/div/div[1]/a[2]",'fanart'=>'@href';
};

my $result = $scraper->scrape($uri);

my $year = $result->{year};
$year = substr($year,0,4);
my $rt = $result->{runtime};
$rt =~ /([0-9]+)/ ;
$runtime = $1;

my $actnum = @{$result->{actor}};
print "actor number = $actnum\n";

foreach my $link (@{$result->{actid}}) {
    my $actor = encode('utf-8',$link);
    print "$actor\n\n";
}

#print $result->{actor}[0];


#my $actor = encode('utf-8',$result->{actor});

my $director = encode('utf-8',$result->{director});
my $studio = encode('utf-8',$result->{studio});
my $plot = encode('utf-8',$result->{plot});
my $thumb = $result->{thumb};
my $fanart = $result->{fanart};

print "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n";
print "<movie>\n";
print "<title>$title</title>\n";
print "<year>$year</year>\n";
print "<runtime>$runtime</runtime>\n";
#print "actor = $actor\n";
print "<director>$director</director>\n";
print "<studio>$studio</studio>\n";
print "<plot>$plot</plot>\n";
print "<thumb>$thumb</thumb>\n";
print "<fanart>$fanart</fanart>\n";
print "</movie>\n";

my $jpg = get($thumb);
# http://pics.dmm.co.jp/mono/movie/adult/adn018/adn018ps.jpg
my @sp = split('/',$thumb);
my $out = $sp[7];
open(OUT, ">$out");
binmode OUT;
print OUT $jpg;
close(OUT);

my $jpg = get($fanart);
my @sp = split('/',$fanart);
my $out = $sp[7];
open(OUT, ">$out");
binmode OUT;
print OUT $jpg;
close(OUT);




