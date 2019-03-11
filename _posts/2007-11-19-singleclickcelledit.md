---
layout: post
category: swing
folder: SingleClickCellEdit
title: JTableのセルをシングルクリックで編集する
tags: [JTable, TableCellEditor]
author: aterai
pubdate: 2007-11-19T13:45:37+09:00
description: JTableのセルをマウスでシングルクリックすると編集状態になるように設定します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTDScXHaI/AAAAAAAAAjw/VQhi8npFmCM/s800/SingleClickCellEdit.png
comments: true
---
## 概要
`JTable`のセルをマウスでシングルクリックすると編集状態になるように設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTDScXHaI/AAAAAAAAAjw/VQhi8npFmCM/s800/SingleClickCellEdit.png %}

## サンプルコード
<pre class="prettyprint"><code>DefaultCellEditor ce = (DefaultCellEditor) table.getDefaultEditor(Object.class);
ce.setClickCountToStart(1);
// ce.setClickCountToStart(2); // default
</code></pre>

## 解説
上記のサンプルでは、`JTable`のセルエディタを起動するのに必要なマウスクリックの回数を、`DefaultCellEditor#setClickCountToStart(...)`メソッドで`1`回に設定しています。

- - - -
- `edit the cell on single click`をチェックした場合、セルレンダラーも変更して、文字列に下線を引くように設定
    - 環境やバージョンによって、以下のように動作が異なる場合がある
        - `WindowsLookAndFeel`の場合、第`0`列目のセルをクリック、選択された行直下の第`1`列目セル上にカーソルを置くと、その文字色が`JDK 1.6.0`と`JDK 1.5.0`で異なる
        - `JDK 1.5.0`で、選択されたときの文字色になる？
        - `Ubuntu 7.10`, `GNOME 2.20.1`, `JDK 1.6.0_03`の場合、`MetalLookAndFeel`と`GTKLookAndFeel`で、`0`行目(`Number.class`)に使われるセルレンダラーが異なる
        - `GTKLookAndFeel`で、`Number.class`なのに左寄せになってしまう？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultCellEditor#setClickCountToStart(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/DefaultCellEditor.html#setClickCountToStart-int-)
- [Swing - JTable - enable cursor blink at cell with single click](https://community.oracle.com/thread/1367289)

<!-- dummy comment line for breaking list -->

## コメント
