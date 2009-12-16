
package File::Path::Hashed;

use strict;
use warnings;

use File::Path qw/make_path/;
use File::Spec;
use Digest::MD5 qw/md5_hex/;
use Carp qw/croak/;

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
    return File::Spec->catfile($base_dir, @subdir);
}

sub make_hash_path {

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

=head1 AUTHOR

Nakano Kyohei (bonar) <bonar@cpan.com>

=head1 SEE ALSO

L<File::Path>

=cut
