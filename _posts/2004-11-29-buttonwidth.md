---
layout: post
title: JButtonなどの高さを変更せずに幅を指定
category: swing
folder: ButtonWidth
tags: [JButton, JComboBox, JTextField, LayoutManager, SpringLayout]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-11-29

## JButtonなどの高さを変更せずに幅を指定
高さはデフォルトのまま幅だけを指定して、`JButton`、`JComboBox`、`JTextField`などのサイズを変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTIYyyZqRI/AAAAAAAAASs/SZslQQaTuFc/s800/ButtonWidth.png)

### サンプルコード
<pre class="prettyprint"><code>Dimension dim = button1.getPreferredSize();
button1.setPreferredSize(new Dimension(100, dim.height));
button2.setPreferredSize(new Dimension(100, dim.height));
Box box1 = Box.createHorizontalBox();
box1.add(Box.createHorizontalGlue());
box1.add(button1);
box1.add(Box.createHorizontalStrut(5));
box1.add(button2);
box1.add(Box.createHorizontalStrut(5));
box1.add(Box.createRigidArea(new Dimension(0, dim.height+10)));
</code></pre>

### 解説
サンプルの下段のように`JButton`の幅を一定にそろえて水平に並べたい場合や、`GridBagLayout`でウエイトを指定するのが面倒といった場合に使用します。

上記のサンプルでは、まず`JButton`の`UI`がフォントサイズや文字列の長さから決めたデフォルトサイズを`getPreferredSize()`で取得しています。高さはそのまま利用し、幅だけ一定の値を設定して、新たなデフォルトサイズを作成し、`setPreferredSize()`しています。これで次から`getPreferredSize()`で帰ってくる値は、どちらのボタンでも全く同じになります。

この`getPreferredSize()`で得られる値を使用するかどうかは、レイアウトマネージャーによって異なりますが、水平方向にコンポーネントを並べる`BoxLayout`の場合は以下のようになるため、パネルをリサイズしても、ボタンのサイズはどちらも同じで変化しません。

- 幅: 推奨サイズ(`getPreferredSize`メソッド)から取得した値
- 高さ: 各コンポーネントの推奨サイズ(`getPreferredSize`メソッド)で得られた中からもっとも大きな値
    - 上記のサンプルで`button1.setPreferredSize(new Dimension(100, 0));`としても結果は同じ

<!-- dummy comment line for breaking list -->

例えば各ボタンを格納した親フレームを`pack()`する前に`JButton#getPreferredSize()`ではなく、`JButton#getSize()`でサイズを取得すると、`[width=0,height=0]`が帰ってきます。コンポーネントが表示されている場合、`getSize()`で得られるサイズは、その実際に表示されているサイズ(レイアウトマネージャーが決める)になります。

以下は`JLabel`を`getPreferredSize()`した場合の例です。初期状態(`preferredSize`が`null`)の場合は、`JLabel`の`UI`がサイズを計算しています。

<pre class="prettyprint"><code>JLabel l = new JLabel();
l.setText("a"); //preferredSizeがnullの場合、UIがサイズを計算
//l.getPreferredSize() -&gt; Dimension[width=6,height=13]

l.setText("aaaa"); //JLabelの場合、Fontサイズと文字列の長さなどで決まる
//l.getPreferredSize() -&gt; Dimension[width=24,height=13]

l.setText("&lt;html&gt;aa&lt;br&gt;aa");
//l.getPreferredSize() -&gt; Dimension[width=12,height=26]

l.setPreferredSize(new Dimension(10,10)); //preferredSizeを設定した場合
//l.getPreferredSize() -&gt; Dimension[width=10,height=10]

l.setPreferredSize(null); //preferredSizeをnullに戻した場合
//l.getPreferredSize() -&gt; Dimension[width=12,height=26]
</code></pre>

- - - -
`JComboBox`、`JTextField`などのコンポーネントでは、[JComboBoxなどの幅をカラム数で指定](http://terai.xrea.jp/Swing/SetColumns.html)のように、カラム数で幅を指定することもできます。

- 注:
    - `JDK 1.5.0`: カラム数で幅を指定すると、コンポーネントによってサイズや余白などが微妙に異なる
    - `JDK 1.6.0`以上: `LookAndFeel`が同じなら、カラム数での幅指定で、どのコンポーネントでもほぼ同じサイズになる

<!-- dummy comment line for breaking list -->

- - - -
`setPreferredSize()`などを使わず、`LayoutManager`で`JButton`の幅を固定したい場合は、例えば`SpringLayout`を以下のように使用する方法などがあります。

<pre class="prettyprint"><code>private static JComponent createRightAlignButtonBox2(
    List&lt;JButton&gt;list, int buttonWidth, int buttonHeight, int gap) {
  SpringLayout layout = new SpringLayout();
  JPanel p = new JPanel(layout);
  SpringLayout.Constraints pCons = layout.getConstraints(p);
  pCons.setConstraint(SpringLayout.SOUTH, Spring.constant(buttonHeight+gap+gap));

  Spring x     = layout.getConstraint(SpringLayout.WIDTH, p);
  Spring y     = Spring.constant(gap);
  Spring g     = Spring.minus(Spring.constant(gap));
  Spring width = Spring.constant(buttonWidth);
  for(JButton b: list) {
    SpringLayout.Constraints constraints = layout.getConstraints(b);
    constraints.setConstraint(SpringLayout.EAST, x = Spring.sum(x, g));
    constraints.setY(y);
    constraints.setWidth(width);
    p.add(b);
    x = Spring.sum(x, Spring.minus(width));
  }
  return p;
}
</code></pre>

### 参考リンク
- [JComboBoxなどの幅をカラム数で指定](http://terai.xrea.jp/Swing/SetColumns.html)
- [SpringLayoutの使用](http://terai.xrea.jp/Swing/SpringLayout.html)
- [Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/how_do_you_layout_command)
    - 専用のレイアウトマネージャを作成するサンプルがあります。

<!-- dummy comment line for breaking list -->

### コメント
- `SpringLayout`などを使って幅を固定する方法を追加(更新日時は忘れました)。スクリーンショットは未更新。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-04-14 (日) 00:36:03

<!-- dummy comment line for breaking list -->

