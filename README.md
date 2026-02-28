# Bitmap Encryption/Decryption

The program applies the following steps:

1. Apply a trail and a tail to the original messages (CCCCCCCCSSSSEE1111444400000000).
2. Compress the message using the Run-Length Encoding (RLE) technique.
3. Prepare the barcode.
4. Use XOR to encrypt the message into the barcode.
5. Save the results as image bitmaps, in BMP format.
6. Test that you can decrypt the message, using again the XOR encryption technique.

To run the program you have to do the following:
- for encryption:
    - set the inputString in the bitmap.s and run the program to get the encoded message in the image.bmp:
      ```
      gcc -no-pie bitmap_encrypt.s -o bitmap_encrypt && ./bitmap_encrypt
      ```
- for decryption:
    - get the message from the image.bmp and print the resulting string:
      ```
      gcc -no-pie bitmap_decrypt.s -o bitmap_decrypt && ./bitmap_decrypt
      ```