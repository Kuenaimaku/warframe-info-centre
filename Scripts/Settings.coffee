blueprintIds = [
    "silver-potato-bp", "golden-potato-bp", "forma-bp",
    "forma-whole", "ash-scorpion-bp", "ash-locust-bp",
    "banshee-reverb-bp", "banshee-chorus-bp", "ember-phoenix-bp",
    "ember-backdraft-bp", "excal-avalon-bp", "excal-pendragon-bp",
    "frost-aurora-bp", "frost-squall-bp", "hydroid-triton-bp",
    "loki-essence-bp", "loki-swindle-bp", "mag-coil-bp",
    "mag-gauss-bp", "nakros-raknis-bp", "nekros-shroud-bp",
    "nova-flux-bp", "nova-quantum-bp", "nyx-menticide-bp",
    "nyx-vespa-bp", "oberon-oryx-bp", "oberon-markhor-bp",
    "rhino-thrak-bp", "rhino-vanguard-helmet-bp", "saryn-hemlock-bp",
    "saryn-chlora-bp", "trinity-aura-bp", "trinity-meridian-bp",
    "valkyr-bastet-bp", "valkyr-kara-bp", "vauban-esprit-bp",
    "vauban-gambit-bp", "vauban-chassis-bp", "vauban-helmet-bp",
    "vauban-systems-bp", "volt-storm-bp", "volt-pulse-bp",
    "zephyr-cierzo-bp", "heatsword-bp", "heatdagger-bp",
    "darksword-bp", "dakdagger-bp", "jawsword-bp",
    "manticore-bp", "brokk-bp", "zoren-dagger-bp", 
    "scindo-dagger-bp"
]

modIds = [
    "constitution-mod", "fortitude-mod", "hammershot-mod",
    "wildfire-mod", "acceleratedblast-mod", "blaze-mod",
    "icestorm-mod", "stunningspeed-mod", "focusenergy-mod",
    "rendingstrike-mod", "vigour-mod", "shred-mod",
    "lethaltorrent-mod"
]

resourceIds = [
    "morphics-mat", "orokincell-mat",
    "gallium-mat", "controlmod-mat",
    "neuralsens-mat", "neurode-mat",
    "circuits-mat", "rubedo-mat",
    "plastids-mat", "ferrite-mat",
    "alloy-mat", "nano-mat",
    "polymer-mat", "salvage-mat"
]

getCheckedOf = ( what ) ->
    return what.map( ( id ) -> $( "#" + id ) ).filter( ( x ) -> x.is( ":checked" ) is yes ).map( ( x ) -> { ID: x.attr( "id" ), Value: x.val() } )

save = ->
    interval = parseInt( $( "#update-interval" ).val() )
    cash     = parseInt( $( "#money-amount" ).val() )
    
    if not isNumber( interval ) or isNaN( interval )
        interval = 60
    
    if not isNumber( cash ) or isNaN( cash )
        cash = 5000
    
    dict = {
        platform: $( "#platform-selector" ).val(),
        updateInterval: if interval.between( 60, 500 ) then interval else 60,
        #notify: $( "#show-notifications" ).is( ":checked" ),
        alerts: {
            showCreditOnly: $( "#money-alert" ).is( ":checked" ),
            minimumCash: cash.between( 1, 99999 ) ? cash : 5000,
            showBlueprint: $( "#track-blueprints" ).is( ":checked" ),
            showNightmare: $( "#track-nightmare-mods" ).is( ":checked" ),
            showResource:  $( "#track-resources" ).is( ":checked" )
        },
        blueprints: getCheckedOf( blueprintIds ),
        mods: getCheckedOf( mod ),
        resources: getCheckedOf( mats )
    }
    
    try
        AppSettings.update dict, ->
    catch e
        console.error e.getMessage()
        alert "Settings could not be updated. Please try again in a few moments."

display = ->
    AppSettings.getAll ( config ) ->
        console.log config
        $( "#platform-selector" ).val config.platform
        $( "#update-interval" ).val config.updateInterval
        #$( "#show-notifications" ).prop "checked", config.notify
        $( "#money-alert" ).prop "checked", config.alerts.showCreditOnly
        $( "#money-amount" ).val config.alerts.minimumCash
        $( "#track-blueprints" ).prop "checked", config.alerts.showBlueprint
        $( "#track-nightmare-mods" ).prop "checked", config.alerts.showNightmare
        $( "#track-resources" ).prop "checked", config.alerts.showResource
        
        __all = [ ]
        __all.append config.blueprints
        __all.append config.mods
        __all.append config.resources
        
        console.log __all
        
        for x in __all
            $( "#" + x ).prop "checked", (yes)
        
        if config.alerts.showBlueprint is (yes)
            $( "#blueprint-table" ).show()
        else
            $( "#blueprint-table" ).hide()
        
        if config.alerts.showNightmare is (yes)
            $( "#mods-table" ).show()
        else
            $( "#mods-table" ).hide()
        
        if config.alerts.showResource is (yes)
            $( "#resource-table" ).show()
        else
            $( "#resource-table" ).hide()
        
        return

checkAllBlueprints = ( c ) ->
    for x in blueprintIds
        $( "#" + x ).prop "checked", c

checkAllMods = ( c ) ->
    for x in modIds
        $( "#" + x ).prop "checked", c

checkAllResources = ( c ) ->
    for x in resourceIds
        $( "#" + x ).prop "checked", c

$( document ).ready ->
    $( "#save-button" ).click save
    
    $( "#bp-check-all" ).click -> checkAllBlueprints (yes)
    $( "#mod-check-all" ).click -> checkAllMods (yes)
    $( "#mats-check-all" ).click -> checkAllResources (yes)
    
    $( "#bp-uncheck-all" ).click -> checkAllBlueprints (no)
    $( "#mod-uncheck-all" ).click -> checkAllMods (no)
    $( "#mats-uncheck-all" ).click -> checkAllResources (no)

    $( "#track-blueprints" ).change ->
        if $( "#track-blueprints" ).is ":checked"
            $( "#blueprint-table" ).show()
        else
            $( "#blueprint-table" ).hide()
    
    $( "#track-nightmare-mods" ).change ->
        if $( "#track-nightmare-mods" ).is ":checked"
            $( "#mod-table" ).show()
        else
            $( "#mod-table" ).hide()
    
    $( "#track-resources" ).change ->
        if $( "#track-resources" ).is ":checked"
            $( "#resource-table" ).show()
        else
            $( "#resource-table" ).hide()

    
    display()
    return