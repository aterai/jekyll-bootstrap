---
layout: post
title: JCheckBoxに不定状態のアイコンを追加する
category: swing
folder: TriStateCheckBox
tags: [JCheckBox, Icon, UIManager, JTableHeader]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-12-12

## JCheckBoxに不定状態のアイコンを追加する
`JCheckBox`の選択状態、非選択状態に加えて、不定状態を表すアイコンを追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-Rs-vnlD35Cg/TuTNCuEvU_I/AAAAAAAABF4/IzDezx4Rq8M/s800/TriStateCheckBox.png)

### サンプルコード
<pre class="prettyprint"><code>JCheckBox checkBox = new JCheckBox("TriState JCheckBox") {
  protected TriStateActionListener listener = null;
  class TriStateActionListener implements ActionListener{
    protected Icon icon;
    public void setIcon(Icon icon) {
      this.icon = icon;
    }
    @Override public void actionPerformed(ActionEvent e) {
      JCheckBox cb = (JCheckBox)e.getSource();
      if(!cb.isSelected()) {
        cb.setIcon(icon);
      }else if(cb.getIcon()!=null){
        cb.setIcon(null);
        cb.setSelected(false);
      }
    }
  }
  @Override public void updateUI() {
    final Icon oi = getIcon();
    removeActionListener(listener);
    setIcon(null);
    super.updateUI();
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        if(listener==null) {
          listener = new TriStateActionListener();
        }
        Icon icon = new IndeterminateIcon();
        listener.setIcon(icon);
        addActionListener(listener);
        if(oi!=null) {
          setIcon(icon);
        }
      }
    });
  }
};
</code></pre>

<pre class="prettyprint"><code>class IndeterminateIcon implements Icon {
    private final Color color = UIManager.getColor("CheckBox.foreground");
    private final Icon icon = UIManager.getIcon("CheckBox.icon");
    @Override public void paintIcon(Component c, Graphics g, int x, int y) {
        icon.paintIcon(c, g, x, y);
        int w = getIconWidth(), h = getIconHeight();
        int a = 4, b = 2;
        Graphics2D g2 = (Graphics2D)g;
        g2.setPaint(Color.BLACK);
        g2.translate(x, y);
        g2.fillRect(a, (h-b)/2, w-a-a, b);
        g2.translate(-x, -y);
    }
    @Override public int getIconWidth()  { return icon.getIconWidth();  }
    @Override public int getIconHeight() { return icon.getIconHeight(); }
}
</code></pre>

### 解説
上記のサンプルでは、`UIManager.getIcon("CheckBox.icon");`で取得した非選択状態のチェックボックスアイコンの上に横棒を引いて不定状態のアイコンを作成しています。

- 不定状態かどうかは、`JCheckBox#getIcon()`が`null`かどうかで判断する手抜き版
- 横棒の色は`UIManager.getColor("CheckBox.foreground");`を使用しているが、`LookAndFeel`によっては無意味
- [JTableHeaderにJCheckBoxを追加してセルの値を切り替える](http://terai.xrea.jp/Swing/TableHeaderCheckBox.html)で使用すると、`NimbusLookAndFeel`の場合だけ、アイコンと文字列のベースラインがずれる？
    - 文字列も`ImageIcon`にして回避
- `NimbusLookAndFeel`で、不定状態アイコンのフォーカスやロールオーバーが表示されない

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JavaSpecialists 145 - TristateCheckBox Revisited](http://www.javaspecialists.eu/archive/Issue145.html)
    - ~~[JavaSpecialists 082 - TristateCheckBox based on the Swing JCheckBox](http://www.javaspecialists.eu/archive/Issue082.html)~~
- [swing - Tristate Checkboxes in Java - Stack Overflow](http://stackoverflow.com/questions/1263323/tristate-checkboxes-in-java)

<!-- dummy comment line for breaking list -->

### コメント