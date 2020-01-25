#!/bin/bash
#INSTALL@ /usr/local/bin/make_photoswipe
WD=`pwd`
BASE=`basename $WD`

tagfile=/tmp/photoswipe.$$.tagfile

cat > swipeindex.html <<EOF
<!DOCTYPE html>
<html lang="en">
	<head>
		<title>$BASE</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="author" content="Code Computerlove  and ljm" />
		<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
		<link href="styles.css" type="text/css" rel="stylesheet" />
		<link href="photoswipe.css" type="text/css" rel="stylesheet" />
		<script  src="lib/jquery-1.6.1.min.js"></script>
		<script  src="lib/simple-inheritance.min.js"></script>
		<!-- NOTE: including the jQuery engine version -->
		<script  src="code-photoswipe-jQuery-1.0.11.min.js"></script>
		<script>
			\$(document).ready(function(){
				\$("#Gallery a").photoSwipe();
			});
		
		</script>
	</head>
	<body>
EOF
if [ -f photoheader ] ; then
	cat photoheader >> swipeindex.html
fi
cat >> swipeindex.html <<EOF
		<div id="MainContent">
			<div class="page-content">
				<h1>$BASE</h1>
			</div>
EOF

#			<p><a href=http://ljm.name/$BASE/htmlswipeindex.html>Fullsize</a></p>
cat >> swipeindex.html <<EOF
			<div id="Gallery">
	
EOF
typeset -i i
i=0
DIR=.
cat imagelist | while read img comment; do

	case a$img in
	(a)
		echo "empty line"
		;;
	(a\#*)
		echo $img
		;;
	(aTYPE*)
		echo TYPE
		;;
	(aHOST*)
		echo hostdirective
		;;
	(aDIR*)
		DIR=$comment
		;;
	(*)
		image=${img%.*}.JPG
		if [ $i = 0 ] ; then
			echo '				<div class="gallery-row">' >> swipeindex.html
			touch $tagfile
		fi
		echo "					<div class=\"gallery-item\">" >> swipeindex.html
		echo "						<a href=\"images/fullsize/$img\">" >> swipeindex.html
		echo "							<img src=\"images/thumb/$img\" alt=\"$comment\" />" >> swipeindex.html
		echo "						</a>" >> swipeindex.html
		echo "					</div><!-- gallery-item -->" >> swipeindex.html
		i=$i+1
		if [ $i = 3 ] ; then
			echo '				</div><!-- gallery-row -->' >> swipeindex.html
			i=0
			rm -f $tagfile
		fi
		;;
	esac
done
if [ -f $tagfile ] ; then
	echo '				</div><!-- gallery-row -->' >> swipeindex.html
	rm -f $tagfile
fi
cat >>swipeindex.html <<EOF
	
			</div><!-- Gallery -->
	
	
		</div><!-- MainContent -->

	
	</body>
</html>
EOF
cp swipeindex.html  photoswipe.html
if [ -d www ] ; then
	cp swipeindex.html  photoswipe.html www
fi

rm -f $tagfile
