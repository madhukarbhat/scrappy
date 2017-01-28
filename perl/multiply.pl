#!/usr/local/bin/perl

# ----------------------------------------------------------------------
# Script Initialization

my $old_fh = select(STDOUT);
$| = 1;
select($old_fh);

my $EASY        = 10;
my $NORMAL      = 6;
my $CHALLENGING = 4;

my $ac = scalar @ARGV;
my $usage = <<"END_OF_USAGE";
Usage:
    $0 <1|2|3|4> <easy|normal|challenging>

<1|2|3>: This is the round number. The round completes once all the
       multiplication questions are asked.

 - Round 1: In round 1, multiplication tables from 2 to 6 will be
   asked in random sequence.

 - Round 2: In round 2, multiplication tables from 6 to 9 will be
   asked in random sequence.

 - Round 3: In round 3, multiplication tables from 9 to 14 will be
   asked in random sequence.

 - Round 4: In round 4, multiplication tables from 14 to 19 will be
   asked in random sequence.

<easy|normal|challenging>: This determines the time available for a
single question.

 - easy        : Question must be answered in roughly $EASY seconds.
 - normal      : Question must be answered in roughly $NORMAL seconds.
 - challenging : Question must be answered in roughly $CHALLENGING seconds.

END_OF_USAGE

# Vaildate parameter
if ($ac != 2) {
  print $usage;
  exit;
}
my $round = shift;
my $qmode = shift;

chomp $round;
chomp $qmode;

# ----------------------------------------------------------------------
# Validate input

if (($round != 1) && ($round != 2) && ($round != 3) && ($round != 4)) {
  print 'Round: ', $round, "\n";
  print $usage;
  exit;
}

if (($qmode !~ m/^easy$/)   &&
    ($qmode !~ m/^normal$/) &&
    ($qmode !~ m/^challenging$/)){
  print 'Round: ', $round, "\t", 'Mode: ', $qmode, "\n";
  print $usage;
  exit;
}


# ----------------------------------------------------------------------
# Alarm setup

# The default timeout value is 'normal' :-)
my $timeout = $NORMAL;

if ($qmode =~ m/challenging/i) {
  $timeout = $CHALLENGING;
} elsif ($qmode =~ m/easy/i) {
  $timeout = $EASY;
} else {
  $timeout = $NORMAL;
}

# ----------------------------------------------------------------------
# Main code
my $question_table  = initialize_question_table();
show_questions($question_table);

# ----------------------------------------------------------------------
# Subroutines

# Build the question table. This is a hash, with each key having a
# randomized sequence number and the corresponding value being the
# question.
sub initialize_question_table {
  my $start_number = 0;
  my $max_number = 0;

  if ($round == 1) {
    $start_number = 2;
    $max_number = 6;
  } elsif ($round == 2) {
    $start_number = 6;
    $max_number = 9;
  } elsif ($round == 3) {
    $start_number = 9;
    $max_number = 14;
  } elsif ($round == 4) {
    $start_number = 14;
    $max_number = 19;
  } else {
    $start_number = 2;
    $max_number = 19;
  }

  my %table = ();
  my $max_questions = ($max_number - $start_number + 1) * 10;

  my @sequence = ();
  for my $j (1..$max_questions) {
    $sequence[$j] = $j;
  }

  for (my $a = $start_number; $a <= $max_number; ++$a) {
    foreach my $i (1..10) {
      my $key_index = int( rand( scalar @sequence ) );
      my $key = $sequence[$key_index];
      splice (@sequence, $key_index, 1);

      my $question = $a." x ".$i;
      my $answer = $a*$i;
      my %value =
        (
         question => $question,
         answer   => $answer
        );
      $table{$key} = \%value;
    }
  }
  return \%table;
}

# Displays the question and waits for timeout seconds for an
# answer. On timeout, it proceeds to the next question.
sub show_questions {
  my $q_table = shift;

  my $previous = select(STDIN);
  $| = 1;
  select($previous);

  foreach my $ques_id (sort  { $a <=> $b } keys %$q_table) {
    eval {
      local $SIG{ALRM} = sub { die "alarm\n" }; # NB: \n required
      alarm $timeout;

      print $ques_id, ". ", $q_table->{$ques_id}->{question}, ": ";
      my $answer = <STDIN>;
      chomp $answer;
      my $correct_answer = $q_table->{$ques_id}->{answer};
      if ($answer == $correct_answer) {
	print "> Correct!";
      } else {
	print "> Wrong. answer is: $correct_answer";
      }
      alarm 0;
    };
    if ($@) {
      die unless $@ eq "alarm\n";        # propagate unexpected errors
      # timed out
      print '  <late>', "\n";
    } else {
      # didn't
      print ' ..', "\n";
    }
  }
  return;
}
