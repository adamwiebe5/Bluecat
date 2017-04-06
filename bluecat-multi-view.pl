#!/usr/bin/perl
#use strict;
#use warnings;
use Proteus::API;
use Socket;

###############
# Retreives IP Addresses associated with specified MAC Address
# Expects 1 input parameters; MAC Address in nnnnnnnnnnnn or nn-nn-nn-nn-nn-nn format
###############


###########!!!!!!!!!!!!!! SET THESE VARIABLES !!!!!!!!!!!!!############
# set the following variables to configure for your specific proteus
##########################################################################################
my $cfg_proteus_address = "10.133.152.30";                  # Address of Proteus server
my $cfg_proteus_api_user = "api_user";                           # Name of API user
my $cfg_proteus_api_password = "z7*yJJKJyr";                       # Password of API user
my $cfg_proteus_api_configuration = "KSUTest";              # Configuration name


#my $debug           = 1;
my $debug = 0;
#######################
# NOTE: Update based on version of Proteus
#######################
#my $cfg_proteus_api_return_string ='//getLinkedEntitiesResponse/result/value';     #Use this for Proteus versions older than 3.1
my $cfg_proteus_api_return_string = '//getLinkedEntitiesResponse/return/item';      #Use this for Proteus versions 3.1 and later

##########################################################################################

my $ip_addr = "";
my @arguments;

# parse input string
for (my $x = $#ARGV ; $x>=0 ; $x--) {
    $arguments[$x] = $ARGV[$x];
    print "Argument $x ".$arguments[$x]."\n" if $debug;
}

$ip_addr = $arguments[0];
$ip_addr2 = $arguments[0];


# test input paramters
if ( $ip_addr ne "" ) {

    my $service = BAMConnection->connect( 'address' => $cfg_proteus_address );
    $service->login(
        SOAP::Data->name( 'username' )->type( 'string' )->value($cfg_proteus_api_user)->attr({xmlns => ''}),
        SOAP::Data->name( 'password' )->type( 'string' )->value($cfg_proteus_api_password)->attr({xmlns => ''})
    );

    ##############
    ## Get Configuration Object
    ##############

    my $configuration = $service->getEntityByName(
            SOAP::Data->type('long')->name('parentId')->value('0')->attr( { xmlns => '' } ),
            SOAP::Data->type('string')->name('name')->value($cfg_proteus_api_configuration)->attr( { xmlns => '' } ),
            SOAP::Data->type('string')->name('type')->value('Configuration')->attr( { xmlns => '' } ))->result;

    $configuration = Service->blessAPIEntity( "object" => $configuration );

    my $cfg_proteus_api_configuration_id = $configuration->get_id();

    print "Configuration ID is $cfg_proteus_api_configuration_id \n\n" if $debug;
    print "\nSearching for IP Address of: $ip_addr\n\n";