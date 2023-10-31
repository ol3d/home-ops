# Testing and Verifying New Hard Drives

## Introduction

This guide focuses on the steps to test and verify new hard drives for your Network Attached Storage (NAS) system. These steps will help ensure the quality and reliability of your chosen drives.

## Drive Testing

Before placing the drives into your NAS, perform the following tests:

### Test Procedure

1. **CrystalDiskInfo Check:**
    - Download and install CrystalDiskInfo on your computer.
    - Connect the new drive externally if needed.
    - Check the drive's SMART status for any initial issues or warnings.

2. **Full Format:**
    - Use your operating system's tools to perform a full format of the drive.
    - This will identify and mark bad sectors, improving drive reliability.

3. **CrystalDiskInfo Check (Post-Format):**
    - Run CrystalDiskInfo again to verify that the formatting process did not introduce any new errors.

4. **CrystalDiskMark (Read/Write/Verify):**
    - Download and install CrystalDiskMark.
    - Perform a full benchmark test (read, write, and verify) to assess drive performance.

5. **CrystalDiskInfo Check (Post-Benchmark):**
    - Run CrystalDiskInfo once more to ensure there are no issues after the intensive benchmark.

6. **Quick Format:**
    - Perform a quick format of the drive using your operating system's tools.

7. **CrystalDiskInfo Check (Post-Quick Format):**
    - Run CrystalDiskInfo again to verify that the quick format did not introduce any issues.

## Final Considerations

- If any errors or issues arise during these tests, consider returning the drive if it's still within the vendor's return window.
- Once you're satisfied with the drive's performance and reliability, you can install it in your NAS.

## Conclusion

Testing and verifying new hard drives for your NAS is essential to ensure data integrity and system stability. By following these steps, you can confidently integrate new drives into your NAS, knowing they have been thoroughly evaluated and are ready for use.

Remember to periodically monitor your drives' health and replace them as needed to maintain the integrity of your NAS storage.
