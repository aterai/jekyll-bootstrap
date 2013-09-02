---
layout: post
title: JTabbedPaneのタブタイトルを変更
category: swing
folder: EditTabTitle
tags: [JTabbedPane, GlassPane, JTextField]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-03-27

## JTabbedPaneのタブタイトルを変更
`JTabbedPane`のタブタイトルを直接編集します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.ggpht.com/_9Z4BYR88imo/TQTMGR-jIQI/AAAAAAAAAYo/g3tGLp5zrdY/s800/EditTabTitle.png)

### サンプルコード
<pre class="prettyprint"><code>class EditableTabbedPane extends JTabbedPane {
  private final MyGlassPane panel  = new MyGlassPane();
  private final JTextField  editor = new JTextField();
  private final JFrame      frame;
  private Rectangle rect;

  public EditableTabbedPane(JFrame frame) {
    this.frame = frame;
    //......
    panel.add(editor);
    frame.setGlassPane(panel);
    panel.setVisible(false);
  }
  class MyGlassPane extends JPanel{
    public MyGlassPane() {
      super((LayoutManager)null);
      setOpaque(false);
      addMouseListener(new MouseAdapter() {
        public void mouseClicked(MouseEvent me) {
          if(rect==null || rect.contains(me.getPoint())) return;
          renameTab();
        }
      });
    }
  }
  private void initEditor() {
    rect = getUI().getTabBounds(this, getSelectedIndex());
    rect.setRect(rect.x+2, rect.y+2, rect.width-2, rect.height-2);
    editor.setBounds(rect);
    editor.setText(getTitleAt(getSelectedIndex()));
  }
  private void startEditing() {
    initEditor();
    panel.setVisible(true);
    editor.requestFocusInWindow();
  }
  private void cancelEditing() {
    panel.setVisible(false);
  }
  private void renameTab() {
    if(editor.getText().trim().length()&gt;0) {
      setTitleAt(getSelectedIndex(), editor.getText());
    }
    panel.setVisible(false);
  }
}
</code></pre>

### 解説
`Excel`風に`JTabbedPane`のタブタイトルを直接編集しています。

編集が開始されると、対象となるタブ上に`JTextField`をレイアウトした`GlassPane`を表示しています。この`GlassPane`には、編集中はフォーカスの移動が起こらないようにするための`FocusTraversalPolicy`などを設定しています。

- 操作方法
    - マウスでタブをダブルクリック、またはタブを選択して<kbd>Enter</kbd>キーで編集開始
    - 編集中に入力欄以外をクリック、または<kbd>Enter</kbd>キーでタイトル文字列が確定
    - 編集中は<kbd>Tab</kbd>キーを押しても無視
    - <kbd>ESC</kbd>キーで編集をキャンセル
    - `0`文字で確定した場合も、キャンセル扱い

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Cursorを砂時計に変更](http://terai.xrea.jp/Swing/WaitCursor.html)
- [JTabbedPaneのタブにJTextFieldを配置してタイトルを編集](http://terai.xrea.jp/Swing/TabTitleEditor.html)
    - `JDK 6`版です。タブに`JTextField`を`JTabbedPane#setTabComponentAt`メソッドを使用して配置しています。
- [Swing - Floating text field](https://forums.oracle.com/thread/1359811)
    - `JPopupMenu`に`JTextField`を配置することで同様のことを行うコードをKelVarnsonさんが投稿しています。

<!-- dummy comment line for breaking list -->

### コメント
- `1.4`系だと編集開始時にうまく選択状態にできない場合があるようです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-03-27 (月) 15:03:01
    - 上記の問題と、選択状態がマウスの移動で外れてしまうバグを修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-03-29 (水) 03:26:56
- 余白などを追加するとエディタがずれるバグを修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-09-01 (金) 15:04:00
- `setTabComponentAt(...)`メソッドで閉じるボタンなどと併用していた場合、編集後に文字列の長さがおかしくなるので、`revalidate()`するように修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-08-10 (火) 16:49:52

<!-- dummy comment line for breaking list -->

