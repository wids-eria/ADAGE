#Client Data Specification

This document specifies the structures that all data logged to ADAGE should be derived from. Game clients can inheret from and add their own fields where needed but all generic ADAGE tools are built to work based on the fields from the base ADAGE data specifications.

###ADAGEData

This is the base structure that all other ADAGE data types inheret from.

<table>
    <tr> 
        <th>Field name</th>
        <th>type</th>
        <th>description</th>
    </tr>
    <tr>
       <td>application_name</td>
       <td>string</td>
       <td>a name for your game</td>
    </tr>
	<tr>
       <td>application_version</td>
       <td>string</td>
       <td>the application token assigned by the ADAGE server for this client</td>
    </tr>
    <tr>
       <td>adage_version</td>
       <td>string</td>
       <td>electric_eel</td>
    </tr>
    <tr>
       <td>timestamp</td>
       <td>string</td>
       <td>Format should be Unix timestamp (Milliseconds since the epoch)</td>
    </tr>
    <tr>
       <td>session_token</td>
       <td>string</td>
       <td>A unique string comprised of the Device ID and the start time of the session. This is used for grouping all logs from one instance of play from applicaiton start to application exit.</td>
    </tr>
     <tr>
       <td>game_id</td>
       <td>string</td>
       <td>A unique string comprised of the the session token plus seconds since start of the application. This game id is used to group logs within a game. If a game allows saving the game id should be stored with the save and restored if that save game is resumed. For multiplayer games all players playing a game together should be reporting the same game_id.</td>
    </tr>
    <tr>
       <td>ada_base_types</td>
       <td>List of strings</td>
       <td>a list of strings containing the names of the ADAGE structures this entry is derived from</td>
    </tr>
    <tr>
       <td>key</td>
       <td>string</td>
       <td>This structures name. should be unique to this game</td>
    </tr>
</table>

###ADAGEVirtualContext

This structure is embedded in other ADAGE structures as a holder for information about the player's progress

<table>
    <tr> 
        <th>Field name</th>
        <th>Type</th>
        <th>description</th>
    </tr>
    <tr>
       <td>level</td>
       <td>string</td>
       <td>The name of the level asset that is currently loaded. In Unity this is the Scene name.</td>
    </tr>
	<tr>
       <td>active_units</td>
       <td>List of strings</td>
       <td>List of strings for uniquely named chunks of gameplay</td>
    </tr>
</table>

###ADAGEPositionalContext

This structure is embedded in other ADAGE structures as a holder for positional information

<table>
    <tr> 
        <th>Field name</th>
        <th>Type</th>
        <th>description</th>
    </tr>
    <tr>
       <td>x</td>
       <td>float</td>
       <td>x coordinate in world space</td>
    </tr>
    <tr>
       <td>y</td>
       <td>float</td>
       <td>y coordinate in world space</td>
    </tr>
	<tr>
       <td>z</td>
       <td>float</td>
       <td>z coordinate in world space</td>
    </tr>

	<tr>
       <td>rotx</td>
       <td>float</td>
       <td>x rotation (Euler angle)</td>
    </tr>
    <tr>
       <td>roty</td>
       <td>float</td>
       <td>y rotation (Euler angle)</td>
    </tr>
	<tr>
       <td>rotz</td>
       <td>float</td>
       <td>z rotation (Euler angle)</td>
    </tr>
</table>

###ADAGEContextStart and ADAGEContextEnd

The structure for the start and end of contexts are the same but seperated for functional reasons. Logging these structures update that active_units list in the virtual context. The contexts are used to tag groups of game play logs into chunks of gameplay. The lookup for the active_unit list is done by name so contexts should be named uniquely.

<table>
    <tr> 
        <th>Field name</th>
        <th>Type</th>
        <th>description</th>
    </tr>
    <tr>
       <td>name</td>
       <td>string</td>
       <td>The unique name of this context</td>
    </tr>
	<tr>
       <td>parent_name</td>
       <td>string</td>
       <td>name of an context that is parent to this context if there is one. Can be null.</td>
    </tr>
    <tr>
       <td>success</td>
       <td>bool</td>
       <td>Set if this context has a notion of success</td>
    </tr>
</table>

###ADAGEGameEvent

The main structure to derive from when logging data that does not have a position. Good for things like system event, player choices, tweaking settings, etc.

<table>
    <tr> 
        <th>Field name</th>
        <th>Type</th>
        <th>description</th>
    </tr>
    <tr>
       <td>virtual_context</td>
       <td>List of strings</td>
       <td>an ADAGEVirtualContext Structure</td>
    </tr>
</table>

###ADAGEPlayerEvent

Derived from ADAGEGameEvent contains the virtual context and positional context

<table>
    <tr> 
        <th>Field name</th>
        <th>Type</th>
        <th>description</th>
    </tr>
    <tr>
       <td>virtual_context</td>
       <td>List of strings</td>
       <td>an ADAGEVirtualContext Structure</td>
    </tr>

    <tr>
       <td>positional_context</td>
       <td>List of strings</td>
       <td>an ADAGEPositionalContext Structure</td>
    </tr>
</table>

###ADAGEDeviceInfo
Logged once on game start up to collect information about the device that the player is currently using.

<table>
    <tr> 
        <th>Field name</th>
        <th>type</th>
        <th>description</th>
    </tr>
    <tr>
       <td>device_model</td>
       <td>string</td>
       <td>The name of the device model</td>
    </tr>
    <tr>
       <td>device_type</td>
       <td>string</td>
       <td>The name of the device type</td>
    </tr>
     <tr>
       <td>device_unique_identifier</td>
       <td>string</td>
       <td>The unique id of the device</td>
    </tr>
     <tr>
       <td>graphics_device_id</td>
       <td>int</td>
       <td>Graphics device id</td>
    </tr>
     <tr>
       <td>graphics_device_name</td>
       <td>string</td>
       <td>The name of the graphics device name</td>
    </tr>
    <tr>
       <td>graphics_device_vendor</td>
       <td>string</td>
       <td>The name of the graphics device vendor</td>
    </tr>
    <tr>
       <td>graphics_device_vendor_id</td>
       <td>int</td>
       <td>The id of the graphics device vendor</td>
    </tr>
    <tr>
       <td>graphics_device_version</td>
       <td>string</td>
       <td>The graphics API version supported by the graphics device</td>
    </tr>
    <tr>
       <td>graphics_memory_size</td>
       <td>int</td>
       <td>Amount of video memory</td>
    </tr>
    <tr>
       <td>graphics_pixel_fillrate</td>
       <td>int</td>
       <td>Approximate pixel fill-rate of the graphics device</td>
    </tr>
    <tr>
       <td>graphics_shader_level</td>
       <td>int</td>
       <td>Graphics device shader capability level</td>
    </tr>
    <tr>
       <td>operating_system</td>
       <td>string</td>
       <td>Name of the operating system including version</td>
    </tr>
    <tr>
       <td>processor_count</td>
       <td>int</td>
       <td>Number of processors</td>
    </tr>
    <tr>
       <td>processor_type</td>
       <td>string</td>
       <td>Type of the processor</td>
    </tr>
    <tr>
       <td>system_memory_size</td>
       <td>int</td>
       <td>Amount of system memory</td>
    </tr>
     <tr>
       <td>supports_accelerometer</td>
       <td>bool</td>
       <td>Is there an accelerometer in this device</td>
    </tr>
     <tr>
       <td>supports_computer_shaders</td>
       <td>bool</td>
       <td>Does this device support computer shaders</td>
    </tr>
     <tr>
       <td>supports_image_effects</td>
       <td>bool</td>
       <td>Does this device support image effects</td>
    </tr>
     <tr>
       <td>supports_instancing</td>
       <td>bool</td>
       <td>Does this device support GPU draw call instancing</td>
    </tr>
     <tr>
       <td>supports_location_service</td>
       <td>bool</td>
       <td>Does this device support location reporting</td>
    </tr>
     <tr>
       <td>supports_render_textures</td>
       <td>bool</td>
       <td>Are render textures supported</td>
    </tr>
 	<tr>
       <td>supports_shadows</td>
       <td>bool</td>
       <td>Are built in shadows supported</td>
    </tr>
     <tr>
       <td>supports_stencil</td>
       <td>int</td>
       <td>I the stencil buffer supported</td>
    </tr>
    <tr>
       <td>supports_vibration</td>
       <td>bool</td>
       <td>Does this devcie support vibration</td>
    </tr>
</table>

