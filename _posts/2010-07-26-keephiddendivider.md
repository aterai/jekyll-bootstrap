---
layout: post
title: JSplitPaneの収納状態を維持する
category: swing
folder: KeepHiddenDivider
tags: [JSplitPane, ActionMap, JButton]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-07-26

## JSplitPaneの収納状態を維持する
`JSplitPane`のサイズが変更されても、ディバイダの収納状態を維持するように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTOy71x7HI/AAAAAAAAAc8/gLDHiIJS_Yw/s800/KeepHiddenDivider.png)

### サンプルコード
<pre class="prettyprint"><code>final Container divider = ((BasicSplitPaneUI)splitPane.getUI()).getDivider();
ButtonModel selectMinModel = null;
ButtonModel selectMaxModel = null;
for(Component c: divider.getComponents()) {
  if(c instanceof JButton) {
    ButtonModel m = ((JButton)c).getModel();
    if(selectMinModel==null &amp;&amp; selectMaxModel==null) {
      selectMinModel = m;
    }else if(selectMaxModel==null) {
      selectMaxModel = m;
    }
  }
}
JButton smin = new JButton("Min:keepHidden");
smin.setModel(selectMinModel);
JButton smax = new JButton("Max:keepHidden");
smax.setModel(selectMaxModel);
</code></pre>

### 解説
- `Min:DividerLocation, Max:DividerLocation`
    - `JSplitPane#setDividerLocation`メソッドで`Divider`の位置を設定
    - `JSplitPane`のリサイズで収納状態が解除される
        
        <pre class="prettyprint"><code>panel.add(new JButton(new AbstractAction("Min:DividerLocation") {
          @Override public void actionPerformed(ActionEvent e) {
            splitPane.setDividerLocation(0);
          }
        }));
</code></pre>
- `Min:Action, Max:Action`
    - `JSplitPane`の`ActionMap`から`selectMax`アクションなどを取得し実行
    - `JSplitPane`のリサイズで収納状態が解除される
        
        <pre class="prettyprint"><code>panel.add(new JButton(new AbstractAction("Max:Action") {
          @Override public void actionPerformed(final ActionEvent e) {
            splitPane.requestFocusInWindow();
            EventQueue.invokeLater(new Runnable() {
              @Override public void run() {
                Action selectMaxAction = splitPane.getActionMap().get("selectMax");
                e.setSource(splitPane);
                selectMaxAction.actionPerformed(e);
              }
            });
          }
        }));
</code></pre>
- `Min:keepHidden, Max:keepHidden`
    - `Divider`に表示されている`JButton`を取得し実行
    - `JSplitPane`がリサイズされても収納状態は維持される

<!-- dummy comment line for breaking list -->

- - - -
[Bug ID: 5006095 Need a way to programmatically stick JSplitPane divider under j2sdk 1.5](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5006095)のようにリフレクションを使って、`BasicSplitPaneUI#setKeepHidden(true)`メソッドを実行して、収納状態を維持する方法もあります。

<pre class="prettyprint"><code>try {
  splitPane.setDividerLocation(0);
  Method setKeepHidden = BasicSplitPaneUI.class.getDeclaredMethod(
      "setKeepHidden", new Class[] { Boolean.class });
  setKeepHidden.setAccessible(true);
  setKeepHidden.invoke(splitPane.getUI(), new Object[] { Boolean.TRUE });
}catch(Exception e) {
  e.printStackTrace();
}
</code></pre>

### 参考リンク
- [Bug ID: 5006095 Need a way to programmatically stick JSplitPane divider under j2sdk 1.5](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5006095)
- [JSplitPaneのディバイダを展開、収納する](http://terai.xrea.jp/Swing/OneTouchExpandable.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JSplitPane.setOneTouchExpandable(true);`を使用せず、`JSplitPane`からコンポーネントを削除(`null`に置き換える)追加することで、収納展開する方法(`setVisible(...)`だと収納はうまくいくけど、正常に展開ができない):  [java - Hide left/right component of a JSplitPane (or different layout) - Stack Overflow](http://stackoverflow.com/questions/14644362/hide-left-right-component-of-a-jsplitpane-or-different-layout) -- [aterai](http://terai.xrea.jp/aterai.html) 2013-02-01 (金) 20:14:58

<!-- dummy comment line for breaking list -->

