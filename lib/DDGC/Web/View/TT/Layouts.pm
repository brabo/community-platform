package DDGC::Web::View::TT::Layouts;
use Moose;

extends 'DDGC::Web::View::TT';

use Template::Stash::XS;
use File::ShareDir;
use HTML::EasyForm;

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
	render_die => 1,
	INCLUDE_PATH => [
		DDGC::Web->path_to('templates'),
		HTML::EasyForm->template_tt_dir,
	],
	PLUGIN_BASE => 'DDGC::Web::Template',
	PRE_PROCESS => 'macros.tt',
	ENCODING => 'utf8',
	COMPILE_DIR => "/tmp/sycontent_web_template_cache_$<",
	STASH => Template::Stash::XS->new,
	RECURSION => 1,
);

sub process {
    my $self = shift;
	my $c = shift;
	$c->stash->{template_layout} ||= [];
	my @layouts = ( @{$c->stash->{template_layout}}, $c->stash->{template} );
	$c->stash->{LAYOUTS} = \@layouts;
	$c->stash->{template} = shift @layouts;
    return $self->next::method($c,@_);
}

1;