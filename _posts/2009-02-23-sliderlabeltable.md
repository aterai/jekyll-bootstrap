---
layout: post
title: JSliderの目盛にアイコンや文字列を追加する
category: swing
folder: SliderLabelTable
tags: [JSlider, JLabel, Icon, JButton]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-02-23

## JSliderの目盛にアイコンや文字列を追加する
`JSlider`の目盛に`JComponent`を表示することで、アイコンを追加したり、文字列の色などを変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTNRK4g8I/AAAAAAAAAkA/dn8dNaWNmxM/s800/SliderLabelTable.png %}

### サンプルコード
<pre class="prettyprint"><code>Hashtable&lt;Integer, Component&gt; labelTable = new Hashtable&lt;&gt;();
int c = 0;
for(String s:Arrays.asList(
    "wi0009-16.png", "wi0054-16.png", "wi0062-16.png",
    "wi0063-16.png", "wi0064-16.png", "wi0096-16.png",
    "wi0111-16.png", "wi0122-16.png", "wi0124-16.png",
    "wi0126-16.png")) {
  labelTable.put(c++,
    new JLabel(s, new ImageIcon(getClass().getResource(s)),
               SwingConstants.RIGHT));
}
labelTable.put(c, new JButton("aaa"));
JSlider slider1 = new JSlider(JSlider.VERTICAL,0,10,0);
slider1.setLabelTable(labelTable);
slider1.setSnapToTicks(true);
slider1.setPaintTicks(true);
slider1.setPaintLabels(true);
</code></pre>

### 解説
上記のサンプルでは、`JSlider#setLabelTable(Dictionary)`メソッドを使用して、任意のキーと値のペアで作成したマップを追加し、スライダーのラベルを以下のように変更しています。

- 左
    - アイコンを設定した`JLabel`と、`JButton`を追加

<!-- dummy comment line for breaking list -->

- 右、下
    - `JLabel`を追加して、目盛の文字列と色を変更

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JSliderのUIや色を変更する](http://terai.xrea.jp/Swing/VolumeSlider.html)
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)

<!-- dummy comment line for breaking list -->

### コメント
