---
layout: post
title: JTableのセルをシングルクリックで編集する
category: swing
folder: SingleClickCellEdit
tags: [JTable, TableCellEditor]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-11-19

## JTableのセルをシングルクリックで編集する
`JTable`のセルをマウスでシングルクリックすると編集状態になるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTTDScXHaI/AAAAAAAAAjw/VQhi8npFmCM/s800/SingleClickCellEdit.png)

### サンプルコード
<pre class="prettyprint"><code>DefaultCellEditor ce = (DefaultCellEditor)table.getDefaultEditor(Object.class);
ce.setClickCountToStart(1);
//ce.setClickCountToStart(2); //default
</code></pre>

### 解説
`DefaultCellEditor#setClickCountToStart`メソッドを使用すれば、編集開始に必要なマウスクリックの回数を設定することができます。

- - - -
`edit the cell on single click`にチェックがある場合は、セルレンダラーも変更して、文字列の下に下線を引いていますが、環境やバージョンによって動作が異なる場合があるようです。

- `WindowsLookAndFeel`の場合、第`0`列目のセルをクリック、選択された行直下の第`1`列目セル上にカーソルを置くと、その文字色が`JDK 1.6.0`と`JDK 1.5.0`で異なる
    - `JDK 1.5.0`で、選択されたときの文字色になる？
- `Ubuntu 7.10`, `GNOME 2.20.1`, `JDK 1.6.0_03`の場合、`MetalLookAndFeel`と`GTKLookAndFeel`で、`0`行目(`Number.class`)に使われるセルレンダラーが異なる
    - `GTKLookAndFeel`で、`Number.class`なのに左寄せになってしまう？

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - JTable - enable cursor blink at cell with single click](https://forums.oracle.com/thread/1367289)

<!-- dummy comment line for breaking list -->

### コメント