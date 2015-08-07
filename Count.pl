#!/usr/bin/perl
my %H;

# ----------------------------------------------------------------------------------------------------------------------------------
# fonction de scan d'un fichier de logs pour compter le nombre d'occurence de chaque regle
# ----------------------------------------------------------------------------------------------------------------------------------
sub ScanLogs {
  my $authen=0;
  my $pasauthen=0;
  my $file = shift;
  my $datelog = shift;
  my $type_log = shift;
  my $nb_lines = 0;
  my $date=`date`;

  local (*IN);
  open (IN, $file)  or die "can not open file $file";

  while (<IN>) {
    $nb_lines++;
    if ( /authen/ )  {
       $authen++;
        }
       else { 
       $pasauthen++;
       }
    } # parcourir toutes les lignes du fichier
  close IN;
  die "Impossible douvrir le fichier\n" unless open(DESC,">>/var/log/resultat_log.txt");
#  print DESC "\n $date $datelog read $nb_lines total\n";
  print DESC "\n$datelog;$nb_lines";
#  print DESC "nombre Logs authen : $authen\n";
#  print DESC "nombre Logs pasauthen : $pasauthen\n";
  close (DESC);
} # ScanLogs


# ----------------------------------------------------------------------------------------------------------------------------------
#  main
# ----------------------------------------------------------------------------------------------------------------------------------
my $ANNEE=`date --date="-1day" '+%Y'` ;
my $MOIS=`date --date="-1day" '+%m'` ;
my $JOUR=`date --date="-1day" '+%d'` ;

chomp $ANNEE;
chomp $MOIS;
chomp $JOUR;
@type = qw ( pasauthen authen );

foreach $t ( @type )
{

$log_name = "logs_debug_$t-" . $ANNEE . '-' . $MOIS . "-" . $JOUR;

 undef %H;
 foreach $file (</var/log/$log_name>) {
   ScanLogs ($file,$log_name,$t);
 }
}
