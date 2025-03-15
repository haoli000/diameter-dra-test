# Testing freeDiameter as DRA (Diameter Routing Agent)

This Docker image is designed to test `freeDiameter` as a Diameter Routing Agent (DRA). The setup includes two interconnected DRA instances (`dra1` and `dra2`) and their respective peers (`peer11`/`peer12` and `peer2`). The purpose of the test is to verify that a message from `peer2` is correctly routed to `peer11`/`peer12` through the DRA instances.

## Testing the Setup

### Scenario Description

- `dra1` and `dra2` are interconnected.  
- `dra1` knows only `peer11` and `peer12`.  
- `dra2` knows only `peer2`.  
- `peer11`, `peer12`, and `peer2` are configured with `test_app`.  
- `peer2` is configured to route all messages to `dra2` using `rt_default`.  
- `dra2` is configured to drop the `Destination-Host` AVP using `rt_rewrite`.  
- The test involves running `kill -10` on the `peer2` process to send a test message.  
- The test message is configured with `dra1.left.side` set as the `Destination-Host`.  
- The test message will be sent to `dra2` according to the configuration above.  
- `dra2` will remove the `Destination-Host` as configured, then route it to `dra1`.  
- `dra1` will randomly select either `peer11` or `peer12` to route the message.  
- The reply will be routed all the way back to `peer2`.  

### Steps to Run the Test

1. **Build and Run the Docker Image**:

   ```bash
   docker build -t freediameter-dra-test .
   docker run -it --rm freediameter-dra-test
   ```

2. **Monitor Logs**:
   Start monitoring the logs of `peer11` and `peer12`:

   ```bash
   tail -f /tmp/peer11.log &
   tail -f /tmp/peer12.log &
   ```

3. **Trigger the Message**:
   Send the `SIGUSR1` signal to `peer2`:

   ```bash
   kill -10 <PID2>
   ```

   Replace `<PID2>` with the process ID of `peer2` (printed by the script).

4. **Verify the Message Routing**:
   Check the `peer11` and `peer12` logs for the following message:

   ```console
   ECHO Test-Request received from 'peer2.right.side', replying...
   ```
   Check the `peer2`logs for the following message:

```concole
  SND to 'dra2.right.side':
       'Test-Request'
         Version: 0x01
         Length: 172
         Flags: 0xC0 (RP--)
         Command Code: 16777214
         ApplicationId: 16777215
         Hop-by-Hop Identifier: 0x7D65B890
         End-to-End Identifier: 0x7FFB823B
          {internal data}: src:(nil)(0) rwb:(nil) rt:0 cb:0x7f2af07febe3,(nil)(0x7f2a08000b70) qry:(nil) asso:0 sess:0x7f2a080014d0
          AVP: 'Session-Id'(263) l=46 f=-M val="peer2.right.side;1742055423;2;app_test"
          AVP: 'Destination-Realm'(283) l=17 f=-M val="left.side"
          AVP: 'Destination-Host'(293) l=22 f=-M val="dra1.left.side"
          AVP: 'Origin-Host'(264) l=24 f=-M val="peer2.right.side"
          AVP: 'Origin-Realm'(296) l=18 f=-M val="right.side"
          AVP: 'Test-AVP'(16777215) vend='app_test vendor'(999999) l=16 f=V- val=304089172 (0x12200854)
  RCV from 'dra2.right.side':
       'Test-Answer'
         Version: 0x01
         Length: 188
         Flags: 0x40 (-P--)
         Command Code: 16777214
         ApplicationId: 16777215
         Hop-by-Hop Identifier: 0x7D65B890
         End-to-End Identifier: 0x7FFB823B
          {internal data}: src:dra2.right.side(15) rwb:(nil) rt:0 cb:(nil),(nil)((nil)) qry:0x7f2a08001350 asso:0 sess:(nil)
          AVP: 'Session-Id'(263) l=46 f=-M val="peer2.right.side;1742055423;2;app_test"
          AVP: 'Test-AVP'(16777215) vend='app_test vendor'(999999) l=16 f=V- val=304089172 (0x12200854)
          AVP: 'Origin-Host'(264) l=24 f=-M val="peer12.left.side"
          AVP: 'Origin-Realm'(296) l=17 f=-M val="left.side"
          AVP: 'Result-Code'(268) l=12 f=-M val='DIAMETER_SUCCESS' (2001 (0x7d1))
          AVP: 'Route-Record'(282) l=24 f=-M val="peer12.left.side"
          AVP: 'Route-Record'(282) l=22 f=-M val="dra1.left.side"
  ```
   
## Logs

Logs for each instance are stored in `/tmp/`:

- `dra1`: `/tmp/dra1.log`
- `peer11`: `/tmp/peer11.log`
- `peer12`: `/tmp/peer12.log`
- `dra2`: `/tmp/dra2.log`
- `peer2`: `/tmp/peer2.log`

## Stopping the Instances

To stop all running instances:

1. Exit the interactive `bash` shell:

   ```bash
   exit
   ```

## Notes

- Ensure you have proper permissions to write logs to `/tmp/` and read the configuration files in `/conf/`.
- Modify the configuration files and logging paths as needed for your environment.
- This setup tests basic message routing through interconnected DRA instances. Additional configurations may be required for advanced use cases.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/YourFeature`).
6. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
