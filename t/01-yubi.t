#!perl

use Mojo::IOLoop;
use Test::More;
use Test::Mojo;
use Data::Dumper;

plan skip_all => 'working sockets required for this test!'
  unless Mojo::IOLoop->new->generate_port;    # Test server
plan tests => 2;

use Mojolicious::Lite;
app->plugin('yubi_verify',
  api_id => 1851,
  api_key => 'oBVbNt7IZehZGR99rvq8d6RZ1DM=',
  parallel => 5,
);
post '/:otp' => sub {
  my $self = shift;
  my $otp = $self->stash('otp');
  my ($key, $res) = $self->yubi_verify($otp, 1);
  $self->render_text(Data::Dumper::Dumper($res));
};

# Tests
my $t = Test::Mojo->new;
$t->post_ok('/cccccccbdbrgcerbebtgkcnihvrgjrikvltbnjdreftc')->content_like(qr/(REPLAYED_OTP|BACKEND_ERROR)/);

1;
