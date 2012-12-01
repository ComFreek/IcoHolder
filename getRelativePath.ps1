<# This is probably not the best code I've ever written, but
   I think it should be readable for most (advanced) users.

   I will wrap this function into a Cmdlet when I have time to do it.
   Feel free to edit this answer and improve it!
#>
function getRelativePath([string]$from, [string]$to, [string]$joinSlash='/') {
    $from = $from -replace "(\\)", "/";
    $to = $to -replace "(\\)", "/";


    $fromArr = New-Object System.Collections.ArrayList;
    $fromArr.AddRange($from.Split("/"));

    $relPath = New-Object System.Collections.ArrayList;
    $relPath.AddRange($to.Split("/"));


    $toArr = New-Object System.Collections.ArrayList;
    $toArr.AddRange($to.Split("/"));

    for ($i=0; $i -lt $fromArr.Count; $i++) {
        $dir = $fromArr[$i];

        # find first non-matching dir
        if ($dir.Equals($toArr[$i])) {
            # ignore this directory
            $relPath.RemoveAt(0);
        }
        else {
            # get number of remaining dirs to $from
            $remaining = $fromArr.Count - $i;
            if ($remaining -gt 1) {
                # add traversals up to first matching dir
                $padLength = ($relPath.Count + $remaining - 1);

                # emulate array_pad() from PHP
                for (; $relPath.Count -ne ($padLength);) {
                    $relPath.Insert(0, "..");
                }
                break;
            }
            else {
                $relPath[0] = "./" + $relPath[0];
            }
        }
    }
    return $relPath -Join $joinSlash;
}