# Testing freeDiameter as DRA (Diameter Routing Agent)

This Docker image is designed to test `freeDiameter` as a Diameter Routing Agent (DRA). The setup includes two interconnected DRA instances (`dra1` and `dra2`) and their respective peers (`peer11`/`peer12` and `peer2`). The purpose of the test is to verify that a message from `peer2` is correctly routed to `peer11`/`peer12` through the DRA instances.

## Testing the Setup

### Scenario Description

- `dra1` and `dra2` are interconnected.
- `dra1` knows only `peer11` and `peer12`.
- `dra2` knows only `peer2`.
- The test involves sending a signal to `peer2` to trigger a message and observing if it is correctly routed to `peer11`/`peer12` via the DRAs.

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
   ECHO Test-Request received from 'peer2.localdomain', replying...
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
