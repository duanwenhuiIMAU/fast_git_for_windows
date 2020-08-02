tree . /f | Out-File -Encoding default tree.txt
if (Test-Path .git){
    git diff tree.txt | Out-File -Encoding default diff.txt 
    $plusLine = Get-content diff.txt|select-string "\+"
    $plusLine = $plusLine -notlike "*@@*"
    $plusLine = $plusLine -notlike "*+++*"
    $minsLine = Get-content diff.txt|select-string "\-"
    $minsLine = $minsLine -notlike "*@@*"
    $minsLine = $minsLine -notlike "*---*"
    $minsLine = $minsLine -notlike "*diff --git*"
    $str = ""
    if ($plusLine.count -ne 0){
        for ($i=0;$i -le $plusLine.count;$i++){
                $str += $plusLine[$i]
            # if($i -gt 5){
            #     break
            # }
        }
            $str += "    =>加   "
    }
    if ($minsLine.count -ne 0){
        for ($i=0;$i -le $minsLine.count;$i++){
                $str += $minsLine[$i]
            #  if($i -gt 5){
            #     break
            # }
        }
            $str += "    =>减   "
    }
    Remove-Item diff.txt
    $str += "|" + $( Get-Date -Format 'yyyy/M/d/H/m' )
    git add tree.txt
    git ci -m $str
}
else {
    git init 
    git add tree.txt
    git ci -m  "文件状态初始化"
}
