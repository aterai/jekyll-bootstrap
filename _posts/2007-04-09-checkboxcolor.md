---
layout: post
title: JCheckBoxのチェックアイコンを変更
category: swing
folder: CheckBoxColor
tags: [JCheckBox, Icon, UIManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-04-09

## JCheckBoxのチェックアイコンを変更
`JCheckBox`で使用するチェックアイコンの色や形を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTI225hC_I/AAAAAAAAATc/YxhkQ5Bq2sk/s800/CheckBoxColor.png)

### サンプルコード
<pre class="prettyprint"><code>JCheckBox cb2 = new JCheckBox("check2");
cb2.setIcon(new MyCheckBoxIcon2());
</code></pre>
<pre class="prettyprint"><code>class MyCheckBoxIcon2 implements Icon {
  private final Icon orgIcon = UIManager.getIcon("CheckBox.icon");
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    orgIcon.paintIcon(c, g, x, y);
    AbstractButton b = (AbstractButton)c;
    ButtonModel model = b.getModel();
    g.setColor(new Color(255, 155, 155, 100));
    g.fillRect(x+2,y+2,getIconWidth()-4,getIconHeight()-4);
    if(model.isSelected()) {
      g.setColor(Color.RED);
      g.drawLine(x+9, y+3, x+9, y+3);
      g.drawLine(x+8, y+4, x+9, y+4);
      g.drawLine(x+7, y+5, x+9, y+5);
      g.drawLine(x+6, y+6, x+8, y+6);
      g.drawLine(x+3, y+7, x+7, y+7);
      g.drawLine(x+4, y+8, x+6, y+8);
      g.drawLine(x+5, y+9, x+5, y+9);
      g.drawLine(x+3, y+5, x+3, y+5);
      g.drawLine(x+3, y+6, x+4, y+6);
    }
  }
  @Override public int getIconWidth() {
    return orgIcon.getIconWidth();
  }
  @Override public int getIconHeight() {
    return orgIcon.getIconHeight();
  }
}
</code></pre>

### 解説
- `org`
    - 通常の`JCheckBox`です。
- `check1`
    - `com/sun/java/swing/plaf/windows/WindowsIconFactory.java`から、`XP`スタイルではない場合のアイコンをコピーし、一部色などを変更しています。
- `check2`
    - `UIManager.getIcon("CheckBox.icon")`で取得したオリジナルのアイコンを、アルファ値を設定した色で上書きし、チェック(レ)も色を変えて塗り潰しています。ただしチェックの形は`WindowsIconFactory`からコピーしているので、別の`LookAndFeel`では枠からはみ出してしまいます。
- `check3`
    - `javax.swing.plaf.metal.MetalCheckBoxIcon`をアルファ値を設定した色で上書きしています。

<!-- dummy comment line for breaking list -->

`check1`～`check3`で生成したアイコンを、それぞれ`JCheckBox#setIcon`で設定しています。

`XP`スタイルで無い場合(`Windows`環境以外ではテストしていない)、色を変更するだけなら、以下のようにする方法もあります。

<pre class="prettyprint"><code>System.setProperty("swing.noxp", "true");
UIManager.put("CheckBox.interiorBackground", new ColorUIResource(Color.GREEN));
UIManager.put("CheckBox.darkShadow", new ColorUIResource(Color.RED));
JCheckBox cb = new JCheckBox("check box");
</code></pre>

### 参考リンク
- [進歩したSynth](http://www.ibm.com/developerworks/jp/java/library/j-synth/)
    - `SynthLookAndFeel`を使って、画像でチェックを描画するサンプルなどが紹介されています。

<!-- dummy comment line for breaking list -->

### コメント