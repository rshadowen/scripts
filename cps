#!/usr/bin/perl

$\ = "\n";
$, = " ";

$UsageMessage = <<END;
Usage: cps [-dhv] <subst> <file> [ <file> ... ]
where:
  -d        Debug option - only show copy names, do not copy.
  -h        Help - show this message.
  -v        Verbose option - list files to copy.
  <subst>   The sed substitution command to run to
	    turn the old filename into the new name.
  <file>    Files to copy.
END


sub Usage
{
  print STDERR $UsageMessage;
  exit 0;
}


sub Do
{
  ($DebugMode || $VerboseMode) && print @_;

  !$DebugMode && system(@_);
}


####
####  main
####


while($_ = $ARGV[0], /^-/)
{
  shift;
  last if (/^--/);
  /^-.*v/ && $VerboseMode++;
  /^-.*d/ && $DebugMode++;
  /^-.*h/ && &Usage;
}

($#ARGV < 1) && &Usage;

$expr = shift;

while($nm = shift)
{
  $fn = $nm;
  eval('$nm =~ '.$expr);
  if ($@)
  {
    warn $@;
  }
  else
  {
    &Do("cp $fn $nm");
  }
}

0;  

