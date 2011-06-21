package Mojolicious::Plugin::HeaderCondition;
use Mojo::Base 'Mojolicious::Plugin';

# "You may have to "metaphorically" make a deal with the "devil".
#  And by "devil", I mean Robot Devil.
#  And by "metaphorically", I mean get your coat."
sub register {
  my ($self, $app) = @_;

  # "headers" condition
  $app->routes->add_condition(
    headers => sub {
      my ($r, $c, $captures, $patterns) = @_;

      # Patterns
      return unless $patterns && ref $patterns eq 'HASH' && keys %$patterns;

      # Match
      while (my ($k, $v) = each %$patterns) {
        my $header = $c->req->headers->header($k);
        if ($header && $v && ref $v eq 'Regexp' && $header =~ $v) {next}
        elsif ($header && defined $v && $v eq $header) {next}
        else                                           {return}
      }
      return 1;
    }
  );
}

1;
__END__

=head1 NAME

Mojolicious::Plugin::HeaderCondition - Header Condition Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('header_condition');

  # Must match all of these headers
  $self->routes->route('/:controller/:action')->over(headers => {
    'X-Secret-Header' => 'Foo',
    Referer => qr/^https?:\/\/example\.com\//
  })->to('foo#bar');

  # Mojolicious::Lite
  plugin 'header_condition';
  get '/' => (headers => {'Referer' => qr/^https?:\/\/example\.com\//})
    => sub {...};

=head1 DESCRIPTION

L<Mojolicious::Plugin::HeaderCondition> is a routes condition for header
based routes.
This is a core plugin, that means it is always enabled and its code a good
example for learning to build new plugins.

=head1 METHODS

L<Mojolicious::Plugin::HeaderCondition> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 C<register>

  $plugin->register;

Register condition in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
