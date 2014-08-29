---
layout: post
title: JTabbedPaneの余白にJButtonを配置
category: swing
folder: TabbedPaneWithButton
tags: [JTabbedPane, OverlayLayout, JButton, UIManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-03-03

## JTabbedPaneの余白にJButtonを配置
`JTabbedPane`のタブエリアに余白を作成し、そこに`OverlayLayout`を使って`JButton`を配置します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTUOdUT3wI/AAAAAAAAAls/N2JYE_Dcr_Y/s800/TabbedPaneWithButton.png %}

### サンプルコード
<pre class="prettyprint"><code>final JButton b = new ToolBarButton(icon);
b.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    tabs.addTab("qwerqwer", new JLabel("yetyet"));
  }
});
tabs = new ClippedTitleTabbedPane() {
  @Override public void updateUI() {
    UIManager.put("TabbedPane.tabAreaInsets", null); //uninstall
    super.updateUI();
    setAlignmentX(0.0f);
    setAlignmentY(0.0f);
    b.setBorder(BorderFactory.createEmptyBorder(3,3,3,3));
    b.setAlignmentX(0.0f);
    b.setAlignmentY(0.0f);
    tabAreaInsets = getTabAreaInsets();
    UIManager.put("TabbedPane.tabAreaInsets",
                  getButtonPaddingTabAreaInsets(b, getTabInsets(), tabAreaInsets));
    super.updateUI();
  }
  private Insets tabAreaInsets = null;
};
JPanel p = new JPanel();
p.setLayout(new OverlayLayout(p));
p.add(button);
p.add(tabs);
</code></pre>

<pre class="prettyprint"><code>//Insets ti = UIManager.getInsets("TabbedPane.tabInsets");
//Insets ai = UIManager.getInsets("TabbedPane.tabAreaInsets");
public Insets getButtonPaddingTabAreaInsets(JButton b, Insets ti, Insets ai) {
  FontMetrics fm = b.getFontMetrics(b.getFont());
  int tih = b.getPreferredSize().height-fm.getHeight()-ti.top-ti.bottom-ai.bottom;
  return new Insets(Math.max(ai.top, tih), b.getPreferredSize().width+ai.left, ai.bottom, ai.right);
}
</code></pre>

### 解説
上記のサンプルは、タブブラウザ風の動作となるように設定しています。

- タブエリアの左上にあるボタンをクリックするとタブが追加される
- メニューからすべてのタブを削除する
- タブエリアに余裕がある場合は`80px`、無い場合は(タブエリアの幅/タブ数)と、常にタブ幅は一定
    - 折り返しや、スクロールが発生するとレイアウトが崩れるため

<!-- dummy comment line for breaking list -->

コンポーネントの追加には、以下の方法を使用しています(比較:[JTabbedPaneの余白にJCheckBoxを配置](http://terai.xrea.jp/Swing/TabbedPaneWithCheckBox.html))。

- ボタンの幅だけ、`tabAreaInsets`の左余白を拡大する
    - `UIManager.getInsets("TabbedPane.tabAreaInsets")`などを使用するため、`Synth`など(`GTK`, `Nimbus`)の`LookAndFeel`には対応していない
    - [Nimbus L&F: java.lang.NullPointer Exception throws when extended BaseUI Components](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6634504)
- `OverlayLayout`で、`JButton`と`JTabbedPane`(上で作った余白に)を重ねて表示
    - このため、`JTabbedPane.TOP`にしか対応していない

<!-- dummy comment line for breaking list -->

### 参考リンク
- [famfamfam.com: Mini Icons](http://www.famfamfam.com/lab/icons/mini/)
    - 追加アイコンを拝借しています。
- [OverlayLayoutの使用](http://terai.xrea.jp/Swing/OverlayLayout.html)
- [JTabbedPaneの余白にJCheckBoxを配置](http://terai.xrea.jp/Swing/TabbedPaneWithCheckBox.html)
- [JTabbedPaneのタイトルをクリップ](http://terai.xrea.jp/Swing/ClippedTabLabel.html)
- [Swing - Any layout suggestions for this?](https://forums.oracle.com/thread/1389350)

<!-- dummy comment line for breaking list -->

### コメント
