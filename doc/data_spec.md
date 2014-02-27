#Client Data Specification

This document specifies the structures that all data logged to ADAGE should be derived from. Game clients can inheret from and add their own fields where needed but all generic ADAGE tools are built to work based on the fields from the base ADAGE data specifications.

###ADAGEData

This is the base structure that all other ADAGE data types inheret from.

<table>
    <tr> 
        <th>Field name</th>
        <th>description</th>
    </tr>
    <tr>
       <td>application_name</td>
       <td>a name for your game</td>
    </tr>
	<tr>
       <td>application_version</td>
       <td>the application token assigned by the ADAGE server for this client</td>
    </tr>
    <tr>
       <td>adage_version</td>
       <td>electric_eel</td>
    </tr>
    <tr>
       <td>timestamp</td>
       <td>Format should be Unix timestamp (Seconds since the epoch)</td>
    </tr>
    <tr>
       <td>session_token</td>
       <td>A unique string comprised of the Device ID and the start time of the session. This is used for grouping all logs from one instance of play from applicaiton start to application exit.</td>
    </tr>
     <tr>
       <td>game_id</td>
       <td>A unique string comprised of the the session token plus seconds since start of the application. This game id is used to group logs within a game. If a game allows saving the game id should be stored with the save and restored if that save game is resumed. For multiplayer games all players playing a game together should be reporting the same game_id.</td>
    </tr>
    <tr>
       <td>ada_base_types</td>
       <td>a list of strings containing the names of the ADAGE structures this entry is derived from</td>
    </tr>
    <tr>
       <td>key</td>
       <td>This structures name. should be unique to this game</td>
    </tr>
</table>

###ADAGEVirtualContext

This structure is embedded in other ADAGE structures as a holder for information about the player's progress

<table>
    <tr> 
        <th>Field name</th>
        <th>description</th>
    </tr>
    <tr>
       <td>level</td>
       <td>The name of the level asset that is currently loaded. In Unity this is the Scene name.</td>
    </tr>
	<tr>
       <td>active_units</td>
       <td>List of strings for uniquely named chunks of gameplay</td>
    </tr>
</table>

###ADAGEPositionalContext

This structure is embedded in other ADAGE structures as a holder for positional information

<table>
    <tr> 
        <th>Field name</th>
        <th>description</th>
    </tr>
    <tr>
       <td>x</td>
       <td>x coordinate in world space</td>
    </tr>
    <tr>
       <td>y</td>
       <td>y coordinate in world space</td>
    </tr>
	<tr>
       <td>z</td>
       <td>z coordinate in world space</td>
    </tr>

	<tr>
       <td>rotx</td>
       <td>x rotation (Euler angle)</td>
    </tr>
    <tr>
       <td>roty</td>
       <td>y rotation (Euler angle)</td>
    </tr>
	<tr>
       <td>rotz</td>
       <td>z rotation (Euler angle)</td>
    </tr>
</table>

###ADAGEContextStart and ADAGEContextEnd

The structure for the start and end of contexts are the same but seperated for functional reasons. Logging these structures update that active_units list in the virtual context. The contexts are used to tag groups of game play logs into chunks of gameplay. The lookup for the active_unit list is done by name so contexts should be named uniquely.

<table>
    <tr> 
        <th>Field name</th>
        <th>description</th>
    </tr>
    <tr>
       <td>name</td>
       <td>The unique name of this context</td>
    </tr>
	<tr>
       <td>parent_name</td>
       <td>name of an context that is parent to this context if there is one. Can be null.</td>
    </tr>
    <tr>
       <td>success</td>
       <td>Set if this context has a notion of success</td>
    </tr>
</table>

###ADAGEGameEvent

The main structure to derive from when logging data that does not have a position. Good for things like system event, player choices, tweaking settings, etc.

<table>
    <tr> 
        <th>Field name</th>
        <th>description</th>
    </tr>
    <tr>
       <td>virtual_context</td>
       <td>an ADAGEVirtualContext Structure</td>
    </tr>
</table>

###ADAGEPlayerEvent

Derived from ADAGEGameEvent contains the virtual context and positional context

<table>
    <tr> 
        <th>Field name</th>
        <th>description</th>
    </tr>
    <tr>
       <td>virtual_context</td>
       <td>an ADAGEVirtualContext Structure</td>
    </tr>
    <tr>
       <td>positional_context</td>
       <td>an ADAGEPositionalContext Structure</td>
    </tr>
</table>

