# LiveKit Application (HTTPS Experiment)

## The needs
folder 0: Prerequisites

```
-> Documentation: Comments and Commands (Detailed/Step by Step) regarding the installation of LiveKit on both Backend Server and Flutter Application.
-> Why? This will allow us 1. to replicate the application using copy-paste commands 2. to build upon those commands and to easily update/updgrade the software.
```

folder 1: Basic Functionality

```
-> Audio and Video Calls between 2 users.
-> Group Audio and Group Video calls between 3 (or more) users.
-> Save/Store any Audio or Video call in the backend server (maybe in mp4 format?) for Security and GDPR purposes.
-> Why? This is a basic functionality that any mobile application uses.
```

folder 2: Extra functionality

```
-> Audio / Video rooms where other people can join.
-> Any other functionality we can implement with LiveKit and find it useful.
-> Why? This extra functionality will allow us to make a more complete app.
```

folder 3: Clubhouse like clone

```
-> Simple Flutter Application that combines the Basic and Extra Functionalities.
```

Goal is to make every process so clean (step by step) and detailed (comments) that we use only copy paste commands.
As a final result, we will have a fully reproducible application and a documentation where we can learn and understand each phase/process of LiveKit software.

## Some Notes:

-> We have to focus mostly on the LiveKit functionality part in order to work fast and without any issues/bugs.

-> We should ***not*** spend time with the UI/UX as it does not add value in functionality.

-> Ofcourse we can add any number of servers/resources that might be required, like a redis or turn server (e.g. CoTurn), if required.

-> Moreover, we can definitely talk about buying code parts that might make the developing process easier, like codecanyon scripts or even find someone who can help us at any issue we might encounter.

## Resources

**Main LiveKit Server - Login Credentials:**
```
ssh-copy-id root@23.88.103.76
ssh root@23.88.103.76
password: livekitapp
```
