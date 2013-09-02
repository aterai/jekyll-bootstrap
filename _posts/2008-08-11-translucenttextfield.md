---
layout: post
title: JTextFieldの背景色を半透明にする
category: swing
folder: TranslucentTextField
tags: [JTextField, Translucent]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-08-11

## JTextFieldの背景色を半透明にする
`JTextField`の背景色を半透明にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTV03Q10yI/AAAAAAAAAoQ/xH8xmeARg4k/s800/TranslucentTextField.png)

### サンプルコード
<pre class="prettyprint"><code>Color BG_COLOR = new Color(1f,.8f,.8f,.2f);

field0 = new JTextField("aaaaaaaaa");
field0.setBackground(BG_COLOR);

field1 = new JTextField("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
field1.setOpaque(false);
field1.setBackground(BG_COLOR);

field2 = new JTextField("cccccccccccccccccccccc") {
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    g2.setPaint(getBackground());
    g2.fillRect(0, 0, getWidth(), getHeight());
    super.paintComponent(g);
  }
};
field2.setOpaque(false);
field2.setBackground(BG_COLOR);
</code></pre>

### 解説
上記のサンプルでは、それぞれアルファ値を使った背景色を`JTextField`に設定しています。

- 上: `field0`
    - 文字列を選択すると、再描画がおかしくなる(残像が表示される)
    - `NimbusLookAndFeel`では、再現しない
- 中: `field1`
    - `setOpaque(false)`とすると、背景色は描画されない
    - `NimbusLookAndFeel`では、背景色が描画される
        - 参考: [Laird Nelson's Blog: Nimbus and Opacity](http://weblogs.java.net/blog/ljnelson/archive/2008/07/nimbus_and_opac.html)
- 下: `field2`
    - `setOpaque(false)`とし、`paintComponent`をオーバーライドして、背景色を描画している

<!-- dummy comment line for breaking list -->

- - - -
- `NimbusLookAndFeel`でのスクリーンショット

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQcFKxPuBpI/AAAAAAAAAqw/1P6cGhtr7FA/s800/TranslucentTextField1.png)

- `GTKLookAndFeel`でのスクリーンショット
    - [Bug ID: 6531760 JTextField not honoring the background color](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6531760)

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTV55zD1gI/AAAAAAAAAoY/0PCTmGDb2AA/s800/TranslucentTextField2.png)

### 参考リンク
- [江戸の文様（和風素材・デスクトップ壁紙）](http://www.viva-edo.com/komon/edokomon.html)
    - 名物裂から雲鶴をサンプルの壁紙として拝借しています。

<!-- dummy comment line for breaking list -->

### コメント
