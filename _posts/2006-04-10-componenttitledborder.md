---
layout: post
title: BorderにJComponentを配置
category: swing
folder: ComponentTitledBorder
tags: [Border, TitledBorder, JCheckBox, JButton]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-04-10

## BorderにJComponentを配置
`Border`に`JCheckBox`や`JButton`などを配置します。[Santhosh Kumar's Weblog](http://www.jroller.com/page/santhosh)の[ComponentTitledBorder](http://www.jroller.com/page/santhosh?entry=component_titled_border)を利用しています。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKEdJmyzI/AAAAAAAAAVY/FTQKJ7__MnE/s800/ComponentTitledBorder.png)

### サンプルコード
<pre class="prettyprint"><code>JCheckBox c = new JCheckBox("CheckBox", true);
c.setFocusPainted(false);
JLabel l1 = new JLabel("adfasdfasdfa");
Border eb = BorderFactory.createEtchedBorder();
l1.setBorder(new ComponentTitledBorder(c, l1, eb));
</code></pre>

### 解説
上記のサンプルは、[Santhosh Kumar's Weblog](http://www.jroller.com/page/santhosh)の[ComponentTitledBorder](http://www.jroller.com/page/santhosh?entry=component_titled_border)を参考にして作成しています。

`SwingUtilities.paintComponent`で`Border`にコンポーネントを描画しているため、`JComboBox`などが選択されてもイベントが伝わりません。このため`ComponentTitledBorder`では、マウスリスナーを設定して`Component#dispatchEvent`メソッドで描画しているコンポーネントにイベントを飛ばしています。

<pre class="prettyprint"><code>@Override public void mouseClicked(MouseEvent me) {
  Component src = me.getComponent();
  tgtCmp.dispatchEvent(SwingUtilities.convertMouseEvent(src, me, tgtCmp));
  src.repaint();
}
</code></pre>

### 参考リンク
- [ComponentTitledBorder](http://www.jroller.com/page/santhosh?entry=component_titled_border)
- [Borderの右下にJComponentを配置](http://terai.xrea.jp/Swing/RightAlignComponentBorder.html)

<!-- dummy comment line for breaking list -->

### コメント
