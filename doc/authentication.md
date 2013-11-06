#Authenticating with ADAGE

ADAGE authentication implements the OAuth 2.0 protocols and acts as both an OAuth provider and a client.

Clients of ADAGE will need to register to obtain an application token and application secret. 

##Unity Client Authentication

When using the [Unity 3D based ADAGE client](https://github.com/wids-eria/adage_unity_client) The following API calls are used. These are available for other clients to use to authenticate registered clients as well.

##POST /auth/authorize_unity

Authorize an application and player through a resource owner password credentials grant

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>email</td>
        <td>email or player_name </td>
    </tr>
    <tr>
        <td>password</td>
        <td>player password</td>
    </tr>
     <tr>
        <td>client_id</td>
        <td>The application's id assigned through the ADAGE developer portal</td>
    </tr>
	 <tr>
        <td>client_secret</td>
        <td>The application's secret</td>
    </tr>
</table>

###Response
The player's authorization token

##POST /auth/authorize_unity_fb
Authorize or create a player based off of an OAuth response recived in the Unity client. The OAuth Response should be passed in the header in typical OAuth fashion.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>client_id</td>
        <td>The application's id assigned through the ADAGE developer portal</td>
    </tr>
	 <tr>
        <td>client_secret</td>
        <td>The application's secret</td>
    </tr>
</table>

###Response
The player's authorization token

##POST /auth/authorize_brainpop
create or find and authorize an ADAGE account based on a brainpop login id.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>client_id</td>
        <td>The application's id assigned through the ADAGE developer portal</td>
    </tr>
	 <tr>
        <td>client_secret</td>
        <td>The application's secret</td>
    </tr>
    <tr>
    	<td>player_id</td>
    	<td>The brainpop id for a player</td>
   	</tr>
</table>

###Response
The player's authorization token

##POST /auth/guest
creates and authorizes a guest account

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>client_id</td>
        <td>The application's id assigned through the ADAGE developer portal</td>
    </tr>
	 <tr>
        <td>client_secret</td>
        <td>The application's secret</td>
    </tr>
</table>

###Response
The player's authorization token




##POST /auth/adage_user
Get information about the current unity user. Typically called after authentication or on app start to get information for display and reference such as email or player_name.

###Response
JSON containing the player information

<table>
    <tr> 
        <th>field</th>
        <th>description</th>
    </tr>
    <tr>
        <td>provider</td>
        <td>ADAGE</td>
    </tr>
	<tr>
        <td>uid</td>
        <td>the players ADAGE uid</td>
    </tr>
    <tr>
        <td>email</td>
        <td>the current players email</td>
    </tr>
    <tr>
        <td>player_name</td>
        <td>the current players name</td>
    </tr>
    <tr>
        <td>guest</td>
        <td>Is this a guest account</td>
    </tr>
</table>
