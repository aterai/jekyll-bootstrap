---
layout: post
title: JSpinnerを編集不可にした場合の内余白
category: swing
folder: InactiveSpinnerInsets
tags: [JSpinner, JTextField, Border, UIManager, LookAndFeel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-08-23

## JSpinnerを編集不可にした場合の内余白
`JSpinner`を編集不可にした場合の背景色や内部余白の色などを変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTOcTAKgdI/AAAAAAAAAcY/R1dvME0C6UA/s800/InactiveSpinnerInsets.png)

### サンプルコード
<pre class="prettyprint"><code>JSpinner spinner3 = new JSpinner() {
  @Override protected void paintComponent(Graphics g) {
    if (getUI() instanceof com.sun.java.swing.plaf.windows.WindowsSpinnerUI) {
      Graphics2D g2d = (Graphics2D) g.create();
      g2d.setPaint(isEnabled()?UIManager.getColor("FormattedTextField.background")
                   :UIManager.getColor("FormattedTextField.inactiveBackground"));
      g2d.fillRect(0,0,getWidth(),getHeight());
      g2d.dispose();
    }
  }
  @Override protected void paintChildren(Graphics g) {
    super.paintChildren(g);
    if (getUI() instanceof com.sun.java.swing.plaf.windows.WindowsSpinnerUI) {
      if (!isEnabled()) {
        Graphics2D g2d = (Graphics2D) g.create();
        Rectangle r = getComponent(0).getBounds();
        r.add(getComponent(1).getBounds());
        r.width--;
        r.height--;
        g2d.setPaint(UIManager.getColor("FormattedTextField.inactiveBackground"));
        g2d.draw(r);
        g2d.dispose();
      }
    }
  }
};
</code></pre>

### 解説
- `Default`
    - `WindowsLookAndFeel(XP)`の場合、`JSpinner`を編集不可にしても白い余白が表示される。
- `setOpaque(false)`
    - `JSpinner#getEditor()`で取得した`JSpinner.DefaultEditor`と、`JSpinner.DefaultEditor#getTextField()`で取得した`JTextField`をそれぞれ、`setOpaque(false)`としている。
    - `WindowsLookAndFeel(XP)`で、`JSpinner`を編集不可にしても背景色は白いままになる。
    - `UIManager.put("FormattedTextField.inactiveBackground", Color.WHITE);`
- `setBorder(...)`
    - 上記と同様に取得した`JSpinner.DefaultEditor`(=`JPanel`)と`JTextField`に以下のような`WindowsLookAndFeel(XP)`用の`Border`を設定している。
        
        <pre class="prettyprint"><code>JSpinner spinner2 = new JSpinner();
        spinner2.setBorder(BorderFactory.createEmptyBorder());
        JSpinner.DefaultEditor editor2 = (JSpinner.DefaultEditor)spinner2.getEditor();
        editor2.setBorder(BorderFactory.createMatteBorder(1,1,1,0, new Color(127,157,185)));
        JTextField field2 = editor2.getTextField();
        field2.setBorder(BorderFactory.createEmptyBorder(2,2,2,0));
</code></pre>
- `paintComponent, paintChildren`
    - `JSpinner#paintComponent()`をオーバーライドして, `WindowsLookAndFeel(XP)`の場合表示される余白(背景色)を`UIManager.getColor("FormattedTextField.inactiveBackground")`で塗りつぶしている。
    - `JSpinner#paintChildren()`をオーバーライドして,  `WindowsLookAndFeel(XP)`の場合表示されるボタン周りの白い余白を塗りつぶしている。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Painting in AWT and Swing](http://www.oracle.com/technetwork/java/painting-140037.html)

<!-- dummy comment line for breaking list -->

### コメント
