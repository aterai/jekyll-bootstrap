---
layout: post
title: JFileChooserのボタンテキストを変更
category: swing
folder: ApproveButtonText
tags: [JFileChooser, UIManager, Mnemonic]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-10-20

## JFileChooserのボタンテキストを変更
`JFileChooser`のボタンテキストを変更します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTHw6_sLrI/AAAAAAAAARs/5fsN5G2p15U/s800/ApproveButtonText.png)

### サンプルコード
<pre class="prettyprint"><code>//UIManager.put("FileChooser.saveButtonText",   "保存(S)");
//UIManager.put("FileChooser.openButtonText",   "開く(O)");
UIManager.put("FileChooser.cancelButtonText", "キャンセル");

JFileChooser fileChooser = new JFileChooser();
//fileChooser.setApproveButtonText("開く(O)");
//fileChooser.setApproveButtonMnemonic('O');
</code></pre>

### 解説
上記のサンプルは、日本語の`WindowsLookAndFeel`に合わせて`JFileChooser`の`ApproveButton`やキャンセルボタンのテキストを以下のように変更しています。

- ~~`OpenDialog`のデフォルトでは、ファイルリストでフォルダが選択されていると「開く(O)」、ファイルが選択されていると「開く」で切り替わるとボタンサイズが変化してしまうため、「開く(O)」に揃える~~
- ~~`SaveDialog`のデフォルトでは、ファイルリストでフォルダが選択されていると「開く(O)」、ファイルが選択されていると「保存」なので、「保存(S)」に揃える~~
    - `CancelButton`のデフォルトは、「取消し」で`SaveDialog`のフォルダ・ファイルの選択が切り替わるとボタンサイズが変化するので、二文字分長い「キャンセル」に変更

<!-- dummy comment line for breaking list -->

### コメント
- `Java 1.6.0_12`以降、デフォルトでは`Mnemonic`の表示がなくなっているようです(もしかしてバグだった？)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-10-09 (金) 20:01:14
    - メモ: [Bug ID: 5045878 &#91;ja&#93; extra mnemonic characters on control buttons in JFileChooser](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5045878) でも、`1.6.0`は関係なさそう…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-10-09 (金) 20:16:41
- `6u18`で復活:[Bug ID: 6785462 Missing "(O)" in JFileChooser Open button in Windows LAF](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6785462) -- [aterai](http://terai.xrea.jp/aterai.html) 2010-06-14 (月) 02:28:39
- `6u27`で、日本語表示の場合などで`Mnemonic`の表示(「開く(O)」の(O)など)が無くなったみたいです: [Bug ID: 7021445 Localization needed on resource string for FileChooser Look and Feel code](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=7021445) -- [aterai](http://terai.xrea.jp/aterai.html) 2011-08-22 (月) 20:23:48
    - `1.7.0`は、「開く(O)」のまま。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-08-22 (月) 20:48:03

<!-- dummy comment line for breaking list -->
