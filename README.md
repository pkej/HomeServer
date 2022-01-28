# Configuring
Running the bin/configure.sh script will make a backup of any existing .env file and create a new one based on the .env-template and information from the current enviornment, user updated files and user input.

## Logged in User
First decide which PGID and PUID to use. If you're running in docker desktop you don't need to do anything.

From the same directory as this README execute this command:
```sh
bin/configure.sh -p PROJECT_NAME
```
## Different User
If you need to use a different user or group you can provide the numeric identifiers via the commandline.

From the same directory as this README execute this command which will give the UID and GID of the user with the login name "USERNAME":
```sh
bin/configure.sh -p PROJECT_NAME -u `id -u USERNAME` -g `id -g USERNAME` -n `id -u -n` -t 'Europe/Oslo'
```

## Files that you can fill in with data
You can create files in the secrets folder and their content will be inserted into the correct variables in the .env file. The reason for doing this is that some docker images accept files as input, while others have to use environment variables. 
<dl>
<dt>`traefik_pilot_token`<dt>
<dd>This token is used to register your traefik instance with your traefik account.<dd>
<dt>`domainname0`<dt>
<dd>This is the domain name of the first domain you want to control. You can also create a second-domain and change the 0 to 1. You can, and must, do the same for any other variable ending with 1, even if you use the same accounts for both services. This is simply due to the fact that the free version of cloudflare only allows one domain per user.<dd>
<dt>`cf_api_key0`<dt>
<dd>This is the api key used by traefik when connecting to cloudflare for creating encryption keys, etc.<dd>
<dt>`cf_email0`<dt>
<dd>This is used by traefik as above<dd>
<dt>`cf_api_token0`<dt>
<dd>This is the api key used by traefik when connecting to cloudflare for updating dynamic ip (cf-ddns) and creating subdomains automatically (cf-companion).<dd>
<dt>`htpasswd`<dt>
<dd>You need to create a ...<dd>
<dt>`mariadb_root_password`<dt>
<dd><dd>
<dt>``<dt>
<dd><dd>
<dt>``<dt>
<dd><dd>
<dt>``<dt>
<dd><dd>
<dt>``<dt>
<dd><dd>
<dt>``<dt>
<dd><dd>
<dt>``<dt>
<dd><dd>
</dl>

# Configuration order
Files in the `secrets` directory will override commandline arguments. Command line arguments will override automatic environment detection.

You will have to create files for most configuration options.