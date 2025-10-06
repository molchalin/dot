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
    foreach my $a (map {unprettify $_} map { (split /,/, $_)[0] } @lines) {
        if ($a =~ /.*$/) {
            push @result, grep {-d $_} glob($a);
        } else {
            push @result, $a;
        }
    }
    return @result;
}

sub read_aliases {
    open my $handle, "<", "$ENV{HOME}/.config/tmux-sessionizer/list";
    chomp(my @lines = <$handle>);
    close $handle;
    my $result1 = {};
    my $result2 = {};
    foreach my $a (@lines) {
        my @arr = split /,/, $a;
        my $path = unprettify $arr[0];
        my $alias = $arr[0];
        if (@arr != 1) {
            $alias = $arr[1];
        }
        $result1->{$path} = $alias;
        $result2->{$alias} = $path;
    }
    return $result1, $result2;
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

    if ($cur eq $root) {
    } elsif (index($cur, $root) == 0) {
        $res = substr($cur, length($root) + 1);
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
    my ($path_to_alias, $alias_to_path) = read_aliases;
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
    for (map {pretty $_} map {$path_to_alias->{$_}} grep {$_ ne $cur} @list) {
        say $_;
    }
} elsif ($ARGV[0] eq "choose") {
    open(my $fh, ">> $ENV{HOME}/.local/state/tmux-sessionizer/order");
    my ($path_to_alias, $alias_to_path) = read_aliases;
    my $path = $alias_to_path->{$ARGV[1]};
    say {$fh} $path;
    close $fh;
    say $path;
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
