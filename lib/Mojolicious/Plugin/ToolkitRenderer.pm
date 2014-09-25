package Mojolicious::Plugin::ToolkitRenderer;
use strict;
use warnings;

use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Exception;
use Template ();

our $VERSION = '1.02';

sub register {
    my ( $self, $app, $settings ) = @_;

    my $template = Template->new( $settings->{'config'} || {
        'RELATIVE'  => 1,
        'EVAL_PERL' => 0,
    } );

    $settings->{'context'}->( $template->context ) if ( $settings->{'context'} );

    $app->renderer->add_handler( 'tt' => sub {
        my ( $renderer, $controller, $output, $options ) = @_;
        my $inline = $settings->{'settings'}{'inline_template'} || 'inline';

        $template->process(
            ( ( $options->{$inline} ) ? \$options->{$inline} : $renderer->template_name($options) ),
            { %{ $controller->stash }, ( $settings->{'settings'}{'controller'} || 'c' ) => $controller },
            $output,
        ) || do {
            $app->log->error( $template->error );

            if (
                $app->mode ne 'development' and
                ref( $settings->{'settings'}{'error_handler'} ) eq 'CODE'
            ) {
                $settings->{'settings'}{'error_handler'}->( $controller, $renderer, $app );
            }
            else {
                my $default_handler = $renderer->default_handler;
                $renderer->default_handler('ep');

                $controller->render_exception(
                    Mojo::Exception->new( __PACKAGE__ . ' - ' . $template->error || '' )
                );

                $renderer->default_handler($default_handler);

                $controller->rendered(
                    ( $template->error and $template->error =~ /not found/ ) ? 404 : 500
                );
            }
        };

        return $$output;
    } );

    $app->helper(
        'render_tt' => sub {
            shift->render( 'handler' => 'tt', @_ );
        }
    );

    return;
}

1;

=pod

=head1 NAME

Mojolicious::Plugin::ToolkitRenderer - Template Toolkit Renderer Mojolicious Plugin

=head1 SYNOPSIS

    # Mojolicious
    $self->plugin(
        'ToolkitRenderer',
        {
            settings => {
                inline_template => 'inline',
                controller      => 'c',
            },
            config => {
                RELATIVE  => 1,
                EVAL_PERL => 0,
                FILTERS   => { ucfirst => sub { return ucfirst shift },
                ENCODING  => 'utf8',
            },
            context => sub {
                shift->define_vmethod( 'scalar', 'upper', sub { return uc shift } );
            },
        },
    );
    $self->renderer->default_handler('tt');

    # Mojolicious::Lite
    plugin ToolkitRenderer => {
        settings => {
            inline_template => 'inline',
            controller      => 'c',
        },
        config => {
            RELATIVE  => 1,
            EVAL_PERL => 0,
            FILTERS   => { ucfirst => sub { return ucfirst shift },
            ENCODING  => 'utf8',
        },
        context => sub {
            shift->define_vmethod( 'scalar', 'upper', sub { return uc shift } );
        },
    };

=head1 DESCRIPTION

This module is a Mojolicious plugin for easy use of L<Template> Toolkit. It
adds a "tt" handler and provides a "render_tt" helper method. It allows for
inline TT and all the usual L<Template> complexities.

=head1 SETUP

When setting up the plugin, you need to provide a hashref of settings that
are in 3 sections.

    {
        config   => {},
        settings => {},
        context  => {},
    }

=head2 config

These are the configuration settings that get passed directly to L<Template>
within it's C<new()> method. (See L<Template> documentation for details.)

=head2 settings

These are settings specific to this plugin, all of which are optional.

    {
        inline_template => 'inline',
        controller      => 'c',
        error_handler   => sub {},
    }

The "inline_template" setting lets you define what keyword you can use to
define an inline template. It defaults to "inline".

    $self->render_tt(
        inline => 'The answer to life, the [% universe | upper %], and [% everything.upper %] is [% answer %].',
        answer => 42, everything => 'everything', universe => 'universe',
    );

The "controller" settings lets your defined what keyword you can use within your
TT templates that will be a reference to the Mojolicious controller.

The "error_handler" setting lets you provide an optional subroutine reference
that will get called if there is any TT errors. By default, when in development
mode, TT errors will surface in the normal Mojolicious helpful way (browser
page and logs). But you can override this.

    error_handler => sub {
        my ( $controller, $renderer, $app ) = @_;

        my $default_handler = $renderer->default_handler;
        $renderer->default_handler('ep');
        $controller->render_exception( Mojo::Exception->new( $template->error ) );
        $renderer->default_handler($default_handler);

        $controller->rendered(500);
    }

=head2 context

This optional setting gives you access to setting vmethods and other things that
require TT's context.

    context => sub {
        my ($context) = @_;
        $context->define_vmethod( 'scalar', 'upper', sub { return uc shift } );
    },

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Plugin>, L<Template>.

=head1 AUTHOR

Gryphon Shafer E<lt>gryphon@cpan.orgE<gt>.

    code('Perl') || die;

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
