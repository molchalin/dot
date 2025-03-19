#!/usr/bin/env perl

use feature(say);
use strict;
use warnings;

sub pretty {
    my ($path) = (@_);
    if (index($path, $ENV{HOME}) == 0) {
        return "~" . substr($path, length($ENV{HOME}));
    }
    return $path;
}

sub unprettify {
    my ($path) = (@_);
    if (index($path, "~") == 0) {
        return $ENV{HOME} . substr($path, 1);
    }
    return $path;
}

sub read_history {
    open my $handle, "<", "$ENV{HOME}/.local/state/tmux-sessionizer/order";
    chomp(my @lines = <$handle>);
    close $handle;
    return reverse @lines;
}

sub read_config {
    open my $handle, "<", "$ENV{HOME}/.config/tmux-sessionizer/list";
    chomp(my @lines = <$handle>);
    close $handle;
    my @result = ();
    foreach my $a (map {unprettify $_} @lines) {
        if ($a =~ /.*$/) {
            push @result, grep {-d $_} glob($a);
        } else {
            push @result, $a;
        }
    }
    return @result;
}

sub uniq {
    my %seen;
    return grep { !$seen{$_}++ } @_;
}

sub current_path {
    if (exists $ENV{TMUX}) {
        my $res = `tmux display-message -p '#{session_path}'`;
        chomp $res;
        return $res;
    }
}

sub realpath {
    my ($root, $cur) = @_;
    my $res = "";

    if (index($cur, $root) == 0) {
        $res = substr($cur, length($root));
    } elsif (index($cur, $ENV{HOME}) == 0) {
        $res = "~" . substr($cur, length($ENV{HOME}));
    } else {
        $res = $cur;
    }
    return $res;
}

if ($ARGV[0] eq "list") {
    my (@config) = read_config;
    my (@order) = read_history;
    my $cur = current_path;

    my %config = map { $_ => 1 } @config;

    my (@list) = grep { exists $config{$_} } uniq @order, @config;

    if (int(rand(10)) == 0) {
        open(my $fh, "> $ENV{HOME}/.local/state/tmux-sessionizer/order");
        for (reverse @list) {
            say {$fh} $_;
        }
        close $fh;
    }
    for (map {pretty $_} grep {$_ ne $cur} @list) {
        say $_;
    }
} elsif ($ARGV[0] eq "choose") {
    open(my $fh, ">> $ENV{HOME}/.local/state/tmux-sessionizer/order");
    say {$fh} unprettify($ARGV[1]);
    close $fh;
    say unprettify($ARGV[1]);
} elsif ($ARGV[0] eq "realpath") {
    my $res = realpath $ARGV[1], $ARGV[2];
    if ($res) {
        print " $res";
    }
} elsif ($ARGV[0] eq "window-list") {
    chomp(my @lines = <STDIN>);
    foreach (@lines) {
        my ($active, $index, $name, $root, $cur) = split /,/, $_;
        my $state = "  ";
        if ($active) {
            $state = "->";
        }
        my $path = realpath $root, $cur;
        say "$state $index $name $path";
    }
}
