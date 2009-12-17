
package File::Path::Hashed;

use strict;
use warnings;

use File::Path qw/make_path/;
use File::Basename qw/dirname/;
use File::Spec;
use Digest::MD5 qw/md5_hex/;
use Carp qw/carp croak/;

use constant {
    DEFAULT_DEPTH  => 2,
    DEFAULT_LENGTH => 2,
};

use base 'Exporter';
our @EXPORT_OK = qw/
    hash_path
    make_hash_path
/;

sub hash_path {
    my %arg = @_;
    my $filename = delete $arg{filename};
    if (!defined $filename) {
        croak 'filename not specified';
    }
    my $base_dir = delete $arg{base_dir} || File::Spec->tmpdir();
    my $depth    = delete $arg{depth};
    if (defined $depth && ($depth !~ /^\d+$/ || 0 == $depth)) {
        croak "invalid depth [$depth]";
    }
    $depth ||= DEFAULT_DEPTH;
    
    my $length = delete $arg{'length'};
    if (defined $length && ($length !~ /^\d+$/ || 0 == $length)) {
        croak "invalid length [$length]";
    }
    $length ||= DEFAULT_LENGTH;

    if (32 < ($depth * $length)) {
        croak 'depth * length must be under 32.';
    }

    my @hash = split //,  md5_hex($filename);
    my (@subdir);
    for (my $i = 0; $i < ($depth * $length); $i += $length) {
        push @subdir, (join '', splice @hash, 0, $length);
    }
    return File::Spec->catfile($base_dir, @subdir, $filename);
}

sub make_hash_path {
    my %arg = @_;

    my $path = hash_path(%arg);
    return if !defined $path;
    return $path if -f $path;

    my $dir = dirname($path);
    return $path if -d $dir;
    unless (make_path($dir)) {
        carp "create path [$dir] failed.";
        return;
    }
    return $path;
}

1;

__END__

=head1 NAME

File::Path::Hashed - generate path including hash value directories

=head1 SYNOPSIS

  use File::Path::Hashed qw/
      hash_path
      make_hash_path
  /);
  
  # create path string
  my $path = hash_path(
      filename => 'foobar.txt',
      base_dir => '/tmp/test',
      depth    => 3,
  ); # returns "/tmp/test/fq/kj/a8/foobar.txt"
  
  # create path with File::Path::make_path
  my $path = make_hash_path(
      filename => 'foobar.txt',
      base_dir => '/tmp/test',
      depth    => 3,
  ); # returns "/tmp/test/fq/kj/a8/foobar.txt"
     # and directory "/tmp/test/fq/kj/a8/" is created.

=head1 DESCRIPTION

When you have to create 10000 files on your local disk or on
servers, It takes time very much to seek files. In such case
you had better create subdirectries to reduce the number of 
the files in one directory.

File::Path::Hashed::make_hash_path() creates subdirectories 
for specified file with MD5 hash value.

=head1 FUNCTION

=over

=item hash_path(filename => $fileame, %options)

returns path string for $filename. example:

  my $path = hash_path(filename => 'foo.txt');
  say $path; # /tmp/4f/d8/foo.txt

This pass consists of it as follows:

  (BASE_DIRECTRY) + (HASH SUBDIRECTORIES) + (FILENAME)

options

=over

=item base_dir

specify base(prefix) directory. File::Spec->tmpdir() is the default.

=item depth

specify hash subdirectory depth. 2 is the default.

  hash_path(filename => 'foo.txt', depth => 3);
  # /tmp/4f/d8/cc/foo.txt

=item length

specify hash subdirectory name length. 2 is the default.

  hash_path(filename => 'foo.txt', length => 4);
  # /tmp/4fd8/cc85/foo.txt

=back

=item make_hash_path(filename => $filename, %option)

create hashed directory for $filename with File::Path::make_path().
Options is same as hash_path().

=back

=head1 AUTHOR

Nakano Kyohei (bonar) <bonar@cpan.com>

=head1 SEE ALSO

L<File::Path>

=cut

