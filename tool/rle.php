<?php
	if ($argc != 4)
		die("Usage: rle.php e/d <input> <output>");
	
	list($_, $mode, $input_file, $output_file) = $argv;
	$mode = strtolower($mode);
	
	if ($mode != 'e' && $mode != 'd')
		die("Invalid mode.");
	if (!file_exists($input_file)) 
		die("Can't find {$input_file}.");
	
	$in  = fopen($input_file, 'rb') or die("Failed to open input file.");
	$out = fopen($output_file, 'wb') or die("Failed to open output file.");
	
	if ($mode == 'd') {
		// Decode
		while (!feof($in)) {
			$c = fgetc($in);
			$b = ord($c);
			if ($b & 0x80) { // MSB set, repeat next byte $b-0x80 times
				if (feof($in))
					trigger_error("Unexpected EOF", E_USER_NOTICE);
				for ($i = 0, $max = ($b & 0x7F), $c = fgetc($in); $i < $max; ++$i)
					fwrite($out, $c);
			} else {
				fwrite($out, $c);
			}
		}
	} else {
		//--
		fseek($in, 0, SEEK_END);
		if (ftell($in) != 0xA00)
			die("The file to compress must be 0xA00 bytes in size.");
		fseek($in, 0, SEEK_SET);
		//--
		
		$last = 0;
		$combo = 0;
		$write_func = function($out, $combo, $last) {
			// bytes > 0x7F are unrepresentable in raw mode
			if ($combo > 1 || $last > 0x7F) {
				fwrite($out, chr(0x80 | $combo).chr($last));
			} else if ($combo > 0) {
				for ($i = 0; $i < $combo; ++$i)
					fwrite($out, chr($last));
			} 
		};
		
		while (!feof($in)) {
			$c = ord(fgetc($in));
			if ($c == $last && $combo < 0x7F) {
				++$combo;
			} else {
				$write_func($out, $combo, $last);
				$last = $c;
				$combo = 1;
			}
		}
		--$combo;
		$write_func($out, $combo, $last);
	}
	fclose($in);
	fclose($out);